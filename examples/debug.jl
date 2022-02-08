using Common
using Visualization
using PyCall

function box_intersects_plane(box::Union{AABB,Volume}, normal::Array{Float64,1}, centroid::Array{Float64,1})

	function pointint(i,j,lambda,allverteces)
		return allverteces[i]+lambda*(allverteces[j]-allverteces[i])
	end

	V,EV,FV = Common.getmodel(box)

	allverteces = [c[:] for c in eachcol(V)]

	vertexpolygon = Vector{Float64}[]
	for (i,j) in EV
		lambda = (Common.LinearAlgebra.dot(normal,centroid)-Common.LinearAlgebra.dot(normal,allverteces[i]))/Common.LinearAlgebra.dot(normal,allverteces[j]-allverteces[i])
		if lambda>=0 && lambda<=1
			push!(vertexpolygon,pointint(i,j,lambda,allverteces))
		end
	end

	if !isempty(vertexpolygon)
		V_int = hcat(vertexpolygon...)
		return Common.remove_double_verts(V_int, 2)[1]
	else
		return nothing
	end
end

function box_intersect_face(aabb::Common.AABB, verts_face::Common.Points)
    function point_in_poly(delaunay_model, point)

        py"""
        from scipy.spatial import Delaunay
        import numpy as np

        def point_in_poly(delaunay_model,point):
            simplices = delaunay_model.find_simplex(point)
            return simplices
        """
        check = py"point_in_poly"(delaunay_model, point)
        return check[1] > 0
    end

    py"""
       from scipy.spatial import Delaunay
       import numpy as np

       def get_delaunay(poly):
           poly = np.array(poly)
           return Delaunay(poly)

       """
    points_box, _, _ = Common.getmodel(aabb)
    delaunay_model = py"get_delaunay"([c[:] for c in eachcol(points_box)])

    n_verts_face = size(verts_face, 2)

    point_in_poly =
        [point_in_poly(delaunay_model, verts_face[:, i]) for i = 1:n_verts_face]
    n_points_in_poly = sum(point_in_poly)
    if n_points_in_poly == n_verts_face
        return true
    elseif n_points_in_poly > 0
        return true
    else
        plane = Plane(verts_face[:, 1:3])
        V = box_intersects_plane(aabb, plane.normal, plane.centroid)
        if !isnothing(V) && size(V, 2) > 0
            return true
        end
    end

    return false
end


aabb = Common.AABB(1, 0, 1, 0, 1, 0)
V, EV, FV = Common.getmodel(aabb)
verts_face = rand(3, 3)
Visualization.VIEW([
    Visualization.GLGrid(V, EV),
    Visualization.points(verts_face),
])
box_intersect_face(aabb, verts_face)

verts_face = [-1 2 2 -1; -1 -1 2 2; 0.5 0.5 0.5 0.5]
Visualization.VIEW([
    Visualization.GLGrid(V, EV),
    Visualization.points(verts_face),
])
box_intersect_face(aabb, verts_face)

verts_face = [-1 2 2 -1; -1 -1 2 2; 10. 10. 10. 10.]
Visualization.VIEW([
    Visualization.GLGrid(V, EV),
    Visualization.points(verts_face),
])
box_intersect_face(aabb, verts_face)
