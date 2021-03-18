
"""
	compute_normals(points::Lar.Points, threshold::Float64, k::Int64)
"""
function compute_normals(points::Lar.Points, threshold::Float64, k::Int64)
	kdtree = Common.KDTree(points)
	normals = zeros(size(points))

	Threads.@threads for i in 1:size(points,2)
		N = Common.neighborhood(kdtree,points,[i],Int[],threshold,k)

		try
			normal,_ = Common.LinearFit(points[:,N])
			normals[:,i] = normal
		catch y

		end

	end
	return normals
end


"""
#TODO
compute_curvatures
"""
#TODO da migliorare
function compute_curvatures(INPUT_PC::PointCloud, par::Float64, threshold::Float64, current_inds = collect(1:INPUT_PC.n_points)::Array{Int64,1})
	points = INPUT_PC.coordinates[:, current_inds]
	npoints = size(points,2)
	corners = fill(false,npoints)
	curvs = fill(0.,npoints)
	balltree = Common.BallTree(points)
	Threads.@threads for i in 1:npoints
		# TODO verificare che i vicini ci siano e che il valore della curvatura non sia NaN
		N = Common.inrange(balltree, points[:,i], par, true) # usare un parametro abbastanza grande
		centroid = Common.centroid(points[:,N])
		C = zeros(2,2)
		for j in N
			diff = points[:,j] - centroid
			C += diff*diff'
		end

		eigval = Lar.eigvals(C)
		curvature = eigval[1]/sum(eigval)
		curvs[i] = curvature
	end
	#mu = Common.mean(curvs)
	for i in 1:npoints
		if  curvs[i] > threshold # TODO parametro da stimare in funzione dei dati.
			corners[i] = true
		end
	end

	return current_inds[corners], curvs
end
