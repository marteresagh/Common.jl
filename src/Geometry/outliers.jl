function relative_density_points(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)
	points = PC.coordinates[:,current_inds]
	_, points_inds = remove_double_verts(PC.coordinates[:,current_inds],2)
	duplicate = setdiff(current_inds,points_inds)

	kdtree = NearestNeighbors.KDTree(points)
	idxs, dists = NearestNeighbors.knn(kdtree, points, k+1, true,  i -> i in duplicate)

	density = Float64[]
	for i in 1:length(current_inds)
		rho = sum(dists[i])/k
		push!(density,1/rho)
	end

	AVGRelDensity = Float64[]
	for i in 1:length(current_inds)
		rel = density[i]/((1/k)*sum(density[idxs[i]]))
		push!(AVGRelDensity,rel)
	end

	return density,AVGRelDensity
end


function outliers(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)
	density,AVGRelDensity = relative_density_points(PC, current_inds, k)
	mu = Statistics.mean(AVGRelDensity)
	rho = Statistics.std(AVGRelDensity)
	outliers = [AVGRelDensity[i]<mu-rho for i in 1:length(current_inds) ]
	return current_inds[outliers]
end
