"""
	neighborhood(	kdtree::NNTree{V},
	 					points::Lar.Points,
		 				seeds::Array{Int64,1},
						visitedverts::Array{Int64,1},
						threshold::Float64,
						k=10::Int64
					 ) where V <: AbstractVector

Return the neighborhood of seed points, removing all points already visited and too distant.
"""
function neighborhood(	kdtree::NNTree{V},
	 					points::Lar.Points,
		 				seeds::Array{Int64,1},
						visitedverts::Array{Int64,1},
						threshold::Float64,
						k=10::Int64
					 ) where V <: AbstractVector


	idxs, dists = NearestNeighbors.knn(kdtree, points[:,seeds], k, true, i -> i in visitedverts)

	neighborhood = Int[]

	for i in 1:length(idxs)
		filter = [dist<=threshold for dist in dists[i]] # remove too distant points
		union!(neighborhood,idxs[i][filter])
	end

	return neighborhood
end


"""
	consistent_seeds(PC::PointCloud, given_seeds::Lar.Points) -> idxs::Array{Int64,1}

Return .
"""
function consistent_seeds(PC::PointCloud)
	kdtree = KDTree(PC.coordinates)
	function consistent_seeds0(given_seed::Array{Float64,1})::Int64
		idx, dist = NearestNeighbors.nn(kdtree,given_seed)
		return idx
	end
	return consistent_seeds0
end

"""
#TODO
"""
#TODO migliorare la procedura
function compute_normals(points::Lar.Points, threshold::Float64, k::Int64)
	kdtree = Common.KDTree(points)
	normals = similar(points)

	Threads.@threads for i in 1:size(points,2)
		N = Common.neighborhood(kdtree,points,[i],Int[],threshold,k)

		if length(N)>=3 # not isolated point
			normal,_ = Common.LinearFit(points[:,N])
			normals[:,i] = normal
		else # isolated point
			normals[:,i] = [0.,0.,0.]
		end

	end
	return normals
end
