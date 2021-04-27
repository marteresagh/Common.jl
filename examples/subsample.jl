using Common
using FileManager
using Visualization
#
# function subsample(P::Lar.Points, p::Float64,par=0.05)
#
# 	function vicinato(s,point,par)
# 		test = true
# 		neigh = [[0,0],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]]
# 		for i in neigh
# 			if haskey(voxs,s+i)
# 				vicini = voxs[s+i]
# 				for vicino in vicini
# 					dist = Lar.norm(point-vicino)
# 					test = test && dist>par
# 					if !test
# 						break
# 					end
# 				end
# 			end
# 		end
# 		return test
# 	end
#
# 	npoints = size(P,2)
# 	voxs = DataStructures.SortedDict{Array{Float64,1},Array{Array{Float64,1},1}}()
# 	for i in 1:npoints
# 		point = P[:,i]
# 		s = floor.(Int,point/p) # compute representative vertex
# 		# 8 vicini
# 		if vicinato(s,point,par)
# 			if haskey(voxs,s)
# 				push!(voxs[s],point)
# 			else
# 				voxs[s] = [point]
# 			end
# 		end
# 	end
# 	a = collect(values(voxs))
# 	decimation = hcat(collect(Iterators.flatten(a))...)
#
# 	# out = Array{Lar.Struct,1}()
# 	# decimation = Array{Float64,1}[]
# 	# for (k,v) in voxs
# 	# 		V = k*p .+ p*[
# 	# 		 0.0 0.0 1.0 1.0;
# 	# 		 0.0 1.0 0.0 1.0]
# 	# 		cell = (V,[[1,2],[2,4],[4,3],[3,1]])
# 	# 		push!(out, Lar.Struct([cell]))
# 	# 		push!(decimation,v...)
# 	# end
# 	# out = Lar.Struct( out )
# 	# V,EV = Lar.struct2lar(out)
# 	# return V,EV,voxs, hcat(decimation...)
# 	return decimation
# end

file = "C:/Users/marte/Documents/GEOWEB/TEST/NAVVIS_LOD3/plane_63784340199709/full_inliers.las"
# #
# potree = "C:/Users/marte/Documents/potreeDirectory/pointclouds/PAVIMENTO_NAVVIS"
# PC = FileManager.source2pc(potree,2)

PC = FileManager.source2pc(file)

# GL.VIEW([
#     Visualization.points(PC.coordinates,PC.rgbs)
# ])


plane = Plane(PC.coordinates)

V2D = Common.apply_matrix(plane.matrix,PC.coordinates)[1:2,:]
decimation = Common.subsample_poisson_disk(V2D)

GL.VIEW([
    Visualization.points(V2D)
	Visualization.points(decimation; color = GL.COLORS[2])
	#GL.GLGrid(V,EV)
])

#
# using AlphaStructures
#
# DT = Common.delaunay_triangulation(decimation)
# filtration = AlphaStructures.alphaFilter(decimation,DT);
# threshold = Common.estimate_threshold(decimation,40)
# _, _, FV = AlphaStructures.alphaSimplex(decimation, filtration, threshold)
#
# GL.VIEW([GL.GLGrid(decimation,FV),	Visualization.points(decimation; color= GL.COLORS[2])])
#
# EV_boundary = Common.get_boundary_edges(decimation,FV)
# W,EW = Lar.simplifyCells(decimation,EV_boundary)
#
# GL.VIEW([    Visualization.points(V2D), GL.GLGrid(W,EW)])
#
