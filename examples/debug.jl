using Common

points = rand(3,10000)
kdtree = Common.KDTree(points)
seeds = [1]
visitedverts = Int[]
threshold = Common.estimate_threshold(PointCloud(points),k)
k = 10

function neighborhood(	kdtree::Common.NNTree{V},
	points::Lar.Points,
	seeds::Array{Int64,1},
	visitedverts::Array{Int64,1},
	threshold::Float64,
	k=10::Int64
	) where V <: AbstractVector


	@time idxs, dists = NearestNeighbors.knn(kdtree, points[:,seeds], k, true, i -> i in visitedverts)

	neighborhood = Int[]

	for i in 1:length(idxs)
		filter = [dist<=threshold for dist in dists[i]] # remove too distant points
		union!(neighborhood,idxs[i][filter])
	end

	return neighborhood
end

@time N = neighborhood(	kdtree,
						points,
						seeds,
						visitedverts,
						threshold,
						k
						)


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

using BenchmarkTools
@btime

normals = Common.compute_normals(points,threshold,k)
