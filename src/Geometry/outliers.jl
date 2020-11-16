"""
relative_density_points(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)

Compute density and relative density of points in PointCloud.
"""
function relative_density_points(V::Lar.Points, current_inds::Array{Int64,1}, k::Int64)
	points = V[:,current_inds]
	npoints = length(current_inds)

	kdtree = NearestNeighbors.KDTree(points)

	idxs = Array{Array{Int64,1},1}(undef,npoints)
	dists = Array{Array{Float64,1},1}(undef,npoints)
	for i in 1:npoints
		idx, dist = NearestNeighbors.knn(kdtree, points[:,i], k, true, t -> t == i)
		idxs[i] = idx
		dists[i] = dist
	end

	density = [k/sum(dists[i]) for i in 1:npoints]

	AVGRelDensity = [density[i]/(sum(density[idxs[i]])/k) for i in 1:npoints]

	return density,AVGRelDensity
end

function relative_density_points(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)
	V = PC.coordinates
	return relative_density_points(V, current_inds, k)
end

"""
Return outliers defined by low relative density.
"""
function outliers(PC::PointCloud, current_inds::Array{Int64,1}, k::Int64)
	density,AVGRelDensity = relative_density_points(PC, current_inds, k)
	mu = Statistics.mean(AVGRelDensity)
	rho = Statistics.std(AVGRelDensity)
	outliers = [AVGRelDensity[i]<mu-rho for i in 1:length(current_inds) ]
	return current_inds[outliers]
end
