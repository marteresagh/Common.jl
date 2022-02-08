using Common
using Visualization
using PyCall
using FileManager
using Detection

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
        V = Common.box_intersects_plane(aabb, plane.normal, plane.centroid)
        if !isnothing(V) && size(V, 2) > 0
            return true
        end
    end

    return false
end


source = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\BOXES"

candidate_points, candidate_faces =
    Detection.read_OFF(raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\BASIC\vect3D\SEGMENTS\candidate_faces.off")

# devo fare un traversal per questo
# se interseca il padre interseca forse anche i figli altrimenti skippo

#
# @time for k in keys(trie)
#     aabb = FileManager.las2aabb(trie[k])
#     faces = []
#     for i in 1:length(candidate_faces)
#         face = candidate_faces[i]
#         if box_intersect_face(aabb, candidate_points[:,face])
#             push!(faces, i)
#         end
#     end
#     trie_faces[k] = faces
# end

trie = FileManager.potree2trie(source)
trie_faces = FileManager.Trie{Vector{Int64}}()


for k in keys(trie)
    faces = Int[]
    trie_faces[k] = faces
end



function dfs(trie, trie_faces, points_face, int_face)# due callback: 1 con controllo e 1 senza controllo

	file = trie.value # path to node file
	nodebb = FileManager.las2aabb(file) # aabb of current octree
	inter = box_intersect_face(nodebb, points_face)
	if inter
		# intersecato ma non contenuto
		# alcuni punti ricadono nel modello altri no
		push!(trie_faces.value, int_face)
		for key in collect(keys(trie.children)) # for all children
			dfs(trie.children[key], trie_faces.children[key], points_face, int_face)
		end
	end

end

for i in 1:length(candidate_faces)
	points = candidate_points[:,candidate_faces[i]]
	dfs(trie, trie_faces, points, i)
end


# scrivi una visualizzazione per prova
