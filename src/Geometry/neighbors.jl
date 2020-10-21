"""
Create the neighborhood of the i-th point defined in seeds
"""
function neighborhood(	kdtree,
	 					PC::PointCloud,
		 				seeds::Array{Int64,1},
						visitedverts::Array{Int64,1},
						threshold::Float64,
						k=10::Int64
					)

	idxs, dists = NearestNeighbors.knn(kdtree, PC.coordinates[:,seeds], k, false, i -> i in visitedverts)

#TODO da migliorare questa parte
	neighborhood = Int[]

	for i in 1:length(idxs)
		filter = [dist<=threshold for dist in dists[i]]
		union!(neighborhood,idxs[i][filter])
	end

	return neighborhood
end
