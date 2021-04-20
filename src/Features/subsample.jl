function subsample_poisson_disk(points::Lar.Points, min_dist=0.05::Float64; step=0.2::Float64 )

	function neighbors_test(s,point,min_dist)
		test = true
		ids_neigh = [[0,0],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]]
		for i in ids_neigh
			if haskey(voxs,s+i)
				p_neigh = voxs[s+i]
				for pt in p_neigh
					dist = Lar.norm(point-pt)
					test = test && dist>min_dist
					if !test
						break
					end
				end
			end
		end
		return test
	end

	npoints = size(points,2)
	voxs = Lar.DataStructures.SortedDict{Array{Float64,1},Array{Array{Float64,1},1}}()
	for i in 1:npoints
		point = points[:,i]
		s = floor.(Int,point/step) # compute representative vertex
		# 8 vicini
		if neighbors_test(s,point,min_dist)
			if haskey(voxs,s)
				push!(voxs[s],point)
			else
				voxs[s] = [point]
			end
		end
	end

    a = collect(values(voxs))
	decimation = hcat(collect(Iterators.flatten(a))...)
    return decimation
end
