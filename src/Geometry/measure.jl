# get area del poligono irregolare.. punti nell'ordine
# function getArea(points::Points)
#
#     if size(points,1) == 2
#         points2D = points
#     else
#         plane = Common.Plane(points)
#         points2D = Common.apply_matrix(plane.matrix,points)[1:2,:]
#     end
#
#     area = 0
#     j = size(points2D, 2) - 1
#     for i = 1:size(points2D, 2)
#         p1 = points2D[:, i]
#         p2 = points2D[:, j]
#         area += (p2[1] + p1[1]) * (p1[2] - p2[2])
#         j = i
#     end
#
#     return abs(area / 2)
# end
#


"""
    build_copEV(EV::Cells, signed=true)
The signed (or not) `ChainOp` from 0-cells (vertices) to 1-cells (edges)
"""
function build_copEV(EV::Cells, signed=true)
    setValue = [-1, 1]
    if signed == false
        setValue = [1, 1]
    end

    maxv = max(map(x->max(x...), EV)...)
    copEV = spzeros(Int8, length(EV), maxv)

    for (i,e) in enumerate(EV)
        e = sort(collect(e))
        copEV[i, e] = setValue
    end

    return copEV
end


"""
    buildFV(EV::Cells, face::Cell)
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a `Cell`(=`SparseVector{Int8, Int}`) and the edges as `Cells`.
"""
function buildFV(EV::Cells, face::Cell)
    return buildFV(build_copEV(EV), face)
end

"""
    buildFV(copEV::ChainOp, face::Cell)
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a `Cell`(=`SparseVector{Int8, Int}`) and the edges as `ChainOp`.
"""
function buildFV(copEV::ChainOp, face::Cell)
    startv = -1
    nextv = 0
    edge = 0

    vs = Array{Int64, 1}()

    while startv != nextv
        if startv < 0
            edge = face.nzind[1]
            startv = copEV[edge,:].nzind[face[edge] < 0 ? 2 : 1]
            push!(vs, startv)
        else
            edge = setdiff(intersect(face.nzind, copEV[:, nextv].nzind), edge)[1]
        end
        nextv = copEV[edge,:].nzind[face[edge] < 0 ? 1 : 2]
        push!(vs, nextv)

    end

    return vs[1:end-1]
end

"""
    buildFV(copEV::ChainOp, face::Array{Int, 1})
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a list of vertex indices and the edges as `ChainOp`.
"""
function buildFV(copEV::ChainOp, face::Array{Int, 1})
    startv = face[1]
    nextv = startv

    vs = []
    visited_edges = []

    while true
        curv = nextv
        push!(vs, curv)

        edge = 0

        for edgeEx in copEV[:, curv].nzind
            nextv = setdiff(copEV[edgeEx, :].nzind, curv)[1]
            if nextv in face && (nextv == startv || !(nextv in vs)) && !(edgeEx in visited_edges)
                edge = edgeEx
                break
            end
        end

        push!(visited_edges, edge)

        if nextv == startv
            break
        end
    end

    return vs
end

"""
    face_area(V::Points, EV::Cells, face::Cell)
The area of `face` given a geometry `V` and an edge topology `EV`.
"""
function face_area(V::Points, EV::Cells, face::Cell)
    return face_area(V, build_copEV(EV), face)
end

function face_area(V::Points, EV::ChainOp, face::Cell)
    function triangle_area(triangle_points::Points)
        ret = ones(3,3)
        ret[:, 1:2] = triangle_points
        return .5*det(ret)
    end

    area = 0

    fv = buildFV(EV, face)

    verts_num = length(fv)
    v1 = fv[1]

    for i in 2:(verts_num-1)

        v2 = fv[i]
        v3 = fv[i+1]

        area += triangle_area(V[[v1, v2, v3], :])
    end

    return area
end



# get convex area
function getArea(V)
    function triangle_area(triangle_points)
        ret = ones(3, 3)
        ret[:,1:2] = triangle_points'
        return Common.abs(0.5 * Common.det(ret))
    end

    if size(V, 1) == 2
        points2D = V
    else
        plane = Common.Plane(V)
        points2D = Common.apply_matrix(plane.matrix, V)[1:2, :]
    end

    triis = Common.delaunay_triangulation(points2D)
    area = 0
    for tri in triis
        area += triangle_area(points2D[:,tri])
    end

    return area
end
