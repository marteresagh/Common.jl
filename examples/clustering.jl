## clustering vector

using Common
using Visualization
using FileManager
using FileManager.JSON

json = raw"C:\Users\marte\Downloads\bundle_casa.json"
json = raw"C:\Users\marte\Downloads\bundle_ODM.json"
json = raw"C:\Users\marte\Downloads\bundle_facciata.json"
function get_pose_shot(json)
	dict = Dict{String,Any}[]

	open(json, "r") do f
	    dict = JSON.parse(f)  # parse and transform data
	end

	img_coord = dict["3dcapture_metadata"]["images_coord"]
	matrici = []
	traslazioni = [img[2:4] for img in img_coord]
	centroid = Common.centroid(hcat(traslazioni...))
	for img in img_coord
		matrix = Matrix{Float64}(Common.I,4,4)
		matrix[1:3, 4] = img[2:4]-centroid
		matrix[1,1] = img[5]
		matrix[1,2] = img[6]
		matrix[1,3] = img[7]
		matrix[2,1] = img[8]
		matrix[2,2] = img[9]
		matrix[2,3] = img[10]
		matrix[3,1] = img[11]
		matrix[3,2] = img[12]
		matrix[3,3] = img[13]
		push!(matrici, matrix)
	end
	return matrici
end

matrici = get_pose_shot(json)
meshes = []
for matrice in matrici
	push!(meshes, Visualization.axis_helper(matrice)...)
end
Visualization.VIEW(meshes)
#
# n = 500
# V = [0. 0. 0.]'
# vectors = Vector{Float64}[]
# for i = 1:n
# 	u = rand()
# 	v = rand()
# 	w = rand()
# 	vector = [u,v,w]/Common.norm([u,v,w])
# 	V = hcat(V,vector)
# 	push!(vectors, vector)
# end
#
# Visualization.VIEW([Visualization.points(V)])
#
# edge = [ [1, i+1] for i in 1:n]
#
# Visualization.VIEW([Visualization.GLGrid(V,edge), Visualization.points(V; color = Visualization.RED)])

vectors = [matrice[1:3,3] for matrice in matrici]


function clustering_vector_by_direction(vectors)
	clusters = Vector{Vector{Float64}}[]

	for vector in vectors
		found = false

		for cluster in clusters
			if Common.dot(vector,cluster[1]) > 0.99
				push!(cluster,vector)
				found = true
				break
			end
		end

		if !found
			push!(clusters, [vector])
		end

	end

	return clusters
end

clusters = clustering_vector_by_direction(vectors)

function draw_clusters(clusters_original)
	clusters_copy = deepcopy(clusters_original)
	model = []
	for cluster in clusters_copy
		prepend!(cluster,[[0.,0.,0]])
		V = hcat(cluster...)
		EV = [[1,i] for i in 2:size(V,2)]
		push!(model,(V,EV))
	end

	mesh_points = []
	mesh_edges = []
	for (V,EV) in model
		color = Visualization.COLORS[rand(1:12)]
		push!(mesh_points, Visualization.points(V; color = color))
		push!(mesh_edges, Visualization.GLGrid(V,EV,color))
	end
	return mesh_points, mesh_edges
end

mesh_points, mesh_edges = draw_clusters(clusters)
Visualization.VIEW([mesh_edges..., mesh_points...])
#
# for i in 1:length(clusters)
# 	@show i
# 	Visualization.VIEW([mesh_edges[i], mesh_points[i]])
# end

# for j in 1:length(clusters)
# 	@show j
# 	cluster = clusters[j]
# 	for i in 2:length(cluster)
# 		println("dot: $(Common.dot(cluster[1], cluster[i])), angle: $(Common.angle_between_directions(cluster[1], cluster[i]))")
# 	end
# end

#
#
#
# using Clustering
# # make a random dataset with 1000 random 5-dimensional points
# X = hcat(vectors...)
# # cluster X into 20 clusters using K-means
# R = kmeans(X, 6; maxiter=200, display=:iter)
#
# a = assignments(R) # get the assignments of points to clusters
# c = counts(R) # get the cluster sizes
# M = R.centers # get the cluster centers
#
# clusters = []
# for i in 1:length(c)
# 	vmap = findall(x->x==i, a)
# 	push!(clusters,vectors[vmap])
# end
#
# mesh_points, mesh_edges = draw_clusters(clusters)
# Visualization.VIEW([mesh_edges..., mesh_points...])
#
# for j in 1:length(clusters)
# 	@show j
# 	cluster = clusters[j]
# 	for i in 2:length(cluster)
# 		println("dot: $(Common.dot(cluster[1], cluster[i])), angle: $(Common.angle_between_directions(cluster[1], cluster[i]))")
# 	end
# end
