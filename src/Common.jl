module Common
    using LinearAlgebra
    using SparseArrays
    using Delaunay
	using QHull

	using Base.Cartesian
	import Base.Prehashed

	# println with flush
	function flushprintln(x...)
		println(join(x, " ")...)
		flush(stdout)
	end

	function flushprint(x...)
		print(join(x, " ")...)
		flush(stdout)
	end

	workdir = dirname(@__FILE__)
	# fondamental struct
	include("Struct/pointcloud.jl")
	include("Struct/topology.jl")
    include("Struct/objects.jl")
	# geometry
	geo = joinpath(workdir,"Geometry")
	for file in readdir(geo)
		include(joinpath(geo,file))
	end
	# from LinearAlgebraicRepresentation
	lar = joinpath(workdir,"LAR")
	for file in readdir(lar)
		include(joinpath(lar,file))
	end
	# model
	mod = joinpath(workdir,"Model")
	for file in readdir(mod)
		include(joinpath(mod,file))
	end

	# dep
	export LineaAlgebra, NearestNeighbors
	#structs
  	export PointCloud, AABB, Volume, Plane, Line #Hypersphere, Hyperplane
	export flushprintln, flushprint #funs
			#monitorInput,  getmodel, NearestNeighbors, Statistics, Lar, LightGraphs #modules
end # module
