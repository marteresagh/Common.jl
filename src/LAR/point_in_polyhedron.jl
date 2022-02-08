#
#	Method to compute an internal point to a polyhedron.
#	----------------------------------------------------
#
#	1. Take two of points close to the opposite sides of any face of a polyhedron, e.g., the first face.
#	2. For each of the two points compute the intersections of a (vertical) ray with the planes (of the faces) intersected by the ray (positive direction of the half-line).
#	3. Transform each such plane and face (and intersection point) to 2D space.
#	4. Test for point-in-polygon intersection.
#	5. Compute the parity of the intersection points for each ray.
#	6. Invariant:  if one is even; the other is odd.
#	7. The initial point with odd number of intersection points is interior to the polyhedron. The other is exterior.
#
function point_in_polyhedron(point, V::Points, EV::Cells, FV::Cells)
    face_intersected = testinternalpoint(V, EV, FV)(point)
    return !(length(face_intersected) % 2 == 0)
end

"""
	testinternalpoint(V::Lar.Points, EV::Lar.Cells, FV::Lar.Cells)
"""
function testinternalpoint(V::Points, EV::Cells, FV::Cells)
    copEV = lar2cop(EV)
    copFV = lar2cop(FV)
    copFE = copFV * copEV'
    I, J, Val = findnz(copFE)
    triple = zip([(i, j, 1) for (i, j, v) in zip(I, J, Val) if v == 2]...)
    I, J, Val = map(collect, triple)
    Val = convert(Array{Int8,1}, Val)
    copFE = sparse(I, J, Val)
    function testinternalpoint0(testpoint)
        intersectedfaces = Int64[]
        # spatial index for possible intersections with ray
        faces = spaceindex(testpoint)((V, FV))
        depot = []
        # face in faces :  indices of faces of possible intersection with ray
        for face in faces
            value = rayintersection(testpoint)(V, FV, face)
            if typeof(value) == Array{Float64,1}
                push!(depot, (face, value))
            end
        end
        # actual containment test of ray point in faces within depot
        for (face, point3d) in depot
            vs, edges, point2d = planemap(V, copEV, copFE, face)(point3d)
            classify = pointInPolygonClassification(vs, edges)
            inOut = classify(point2d)
            if inOut != "p_out"
                push!(intersectedfaces, face)
            end
        end
        return intersectedfaces
    end
    return testinternalpoint0
end


function pboundingbox(vertices::Points)
    a = [extrema(vertices[i,:]) for i in 1:size(vertices,1)]
    minimum = Float64[]
    maximum = Float64[]
    for (min,max) in a
       push!(minimum,min)
       push!(maximum,max)
    end
    return minimum, maximum
end

function coordintervals(coord, bboxes)
    boxdict = OrderedDict{Array{Float64,1},Array{Int64,1}}()
    for (h, box) in enumerate(bboxes)
        key = box[coord, :]
        if haskey(boxdict, key) == false
            boxdict[key] = [h]
        else
            push!(boxdict[key], h)
        end
    end
    return boxdict
end

function boxcovering(bboxes, index, tree)
    covers = [[] for k = 1:length(bboxes)]
    for (i, boundingbox) in enumerate(bboxes)
        extent = bboxes[i][index, :]
        iterator = IntervalTrees.intersect(tree, tuple(extent...))
        for x in iterator
            append!(covers[i], x.value)
        end
    end
    return covers
end

"""
	spaceindex(point3d)(model)
Compute the set of face boxes of possible intersection with a point-ray.
Work in 3D, where the ray direction is parallel to the z-axis.
Return an array of indices of face.
#	Example
```
julia> V,(VV,EV,FV,CV) = Lar.cuboidGrid([1,1,1],true)
julia> spaceindex([.5,.5,.5])((V,FV))
3-element Array{Int64,1}:
 5
 6
```
"""
function spaceindex(point3d::Array{Float64,1})::Function
    function spaceindex0(model::LAR)::Array{Int,1}
        V, CV = copy(model[1]), copy(model[2])
        V = [V point3d]
        dim, idx = size(V)
        push!(CV, [idx, idx, idx])
        cellpoints = [V[:, CV[k]]::Points for k = 1:length(CV)]
        #----------------------------------------------------------
        bboxes = [hcat(pboundingbox(cell)...) for cell in cellpoints]
        xboxdict = coordintervals(1, bboxes)
        yboxdict = coordintervals(2, bboxes)
        # xs,ys are IntervalTree type
        xs = IntervalTrees.IntervalMap{Float64,Array}()
        for (key, boxset) in xboxdict
            xs[tuple(key...)] = boxset
        end
        ys = IntervalTrees.IntervalMap{Float64,Array}()
        for (key, boxset) in yboxdict
            ys[tuple(key...)] = boxset
        end
        xcovers = boxcovering(bboxes, 1, xs)
        ycovers = boxcovering(bboxes, 2, ys)
        covers = [intersect(pair...) for pair in zip(xcovers, ycovers)]

        # add new code part

        # remove each cell from its cover
		pointcover = setdiff(covers[end], length(CV))
        return pointcover
    end
    return spaceindex0
end

"""
	rayintersection(point3d::Array{Float64})(V,FV,face::Int)
Compute the intersection point of the vertical line through `point3d` w `face`.
If the face is parallel to `z axis` return `false`.
# Example
```
julia> V,(VV,EV,FV,CV) = Lar.simplex(3,true);
julia> V
3×4 Array{Float64,2}:
 0.0  1.0  0.0  0.0
 0.0  0.0  1.0  0.0
 0.0  0.0  0.0  1.0
julia> FV
4-element Array{Array{Int64,1},1}:
 [1, 2, 3]
 [1, 2, 4]
 [1, 3, 4]
 [2, 3, 4]
 julia> Lar.rayintersection([.333,.333,0])(V,FV,4)
 3-element Array{Float64,1}:
  0.333
  0.333
  0.3340000000000001
```
"""
function rayintersection(point3d)
    function rayintersection0(V, FV, face::Int)
        l0, l = point3d, [0, 0, 1.0]
        ps = V[:, FV[face]]  # face points
        p0 = ps[:, 1]
        v1, v2 = ps[:, 2] - p0, ps[:, 3] - p0
        n = LinearAlgebra.normalize(cross(v1, v2))

        denom = LinearAlgebra.dot(n, l)
        if (abs(denom) > 1e-8) #1e-6
            p0l0 = p0 - l0
            t = dot(p0l0, n) / denom
            if t > 0
                return l0 + t * l
            end
        else
            #error("ray and face are parallel")
            return false
        end
    end
    return rayintersection0
end


"""
	planemap(V,copEV,copFE,face)(point)
Tranform the 3D face and the 3D point in their homologous 2D, in order to test for containment.
"""

function planemap(V, copEV, copFE, f)
	face,signs = Common.SparseArrays.findnz(copFE[f,:])
	vpairs = [s>0 ? Common.SparseArrays.findnz(copEV[e,:])[1] :
					reverse(SparseArrays.findnz(copEV[e,:])[1])
				for (e,s) in zip(face,signs)]
	a = [pair for pair in vpairs if length(pair)==2]
	vs = union(a...)
	vdict = Dict(zip(vs,1:length(vs)))
	edges = [[vdict[pair[1]], vdict[pair[2]]] for pair in vpairs if length(pair)==2]
	points = V[:,vs]

    function planemap0(point)
        plane = Common.Plane(points)
		outvs = Common.apply_matrix(plane.matrix,points)
		outpoint = Common.apply_matrix(plane.matrix,point)
        return outvs[1:2,:], edges, outpoint[1:2,:]
    end
    return planemap0
end

# 
# # FROM python
# function point_in_poly(points, point)
#
#     py"""
#     from scipy.spatial import Delaunay
#     import numpy as np
#
#     def get_delaunay(poly):
#         poly = np.array(poly)
#         return Delaunay(poly)
#
#     """
#
#     delaunay_model = py"get_delaunay"([c[:] for c in eachcol(points)])
#
#     py"""
#     from scipy.spatial import Delaunay
#     import numpy as np
#
#     def point_in_poly(delaunay_model,point):
#         simplices = delaunay_model.find_simplex(point)
#         return simplices
#     """
#     check = py"point_in_poly"(delaunay_model, point)
#     return check[1] > 0
# end
