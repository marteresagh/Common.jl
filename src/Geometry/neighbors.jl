function neighborhood(	kdtree,
	 					PC::PointCloud,
		 				seeds::Array{Int64,1},
						visitedverts::Array{Int64,1},
						threshold::Float64,
						k=10
					)
	idxs, dists = knn(kdtree, PC.points[:,seeds], k, false, i -> i in visitedverts)

	neighborhood = Int[]

	for i in 1:length(idxs)
		filter = [dist<=threshold for dist in dists[i]]
		union!(neighborhood,idxs[i][filter])
	end

	return neighborhood
end
