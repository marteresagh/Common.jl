__precompile__()

module Common

	using LinearAlgebraicRepresentation
	Lar = LinearAlgebraicRepresentation
	using SparseArrays
	using LightGraphs

	using NearestNeighbors
	using Delaunay
	using Statistics

	using Base.Cartesian
	import Base.Prehashed

	# println with flush
	function flushprintln(x...)
		println(join(x, " ")...)
		flush(stdout)
	end

	# include struct
	include("struct.jl")
	include("keyboard_event.jl")

	# features
	include("Features/neighbors.jl")
	include("Features/estimation.jl")
	include("Features/double_verts.jl")
	include("Features/outliers.jl")
	# geometry
	include("Geometry/residual.jl")
	include("Geometry/fit.jl")
	include("Geometry/util.jl")
	include("Geometry/tools.jl")
	include("Geometry/delaunay.jl")
	include("Geometry/aabb.jl")
	# graph
	include("Graph/graph.jl")
	include("Graph/boundary.jl")
	# model
	include("Model/intersection.jl")
	include("Model/getmodel.jl")

	export  PointCloud, Hyperplane, AABB, Volume, Plane, Hypersphere, #structs
			monitorInput, flushprintln, getmodel, #funs
			NearestNeighbors, Statistics, Lar, LightGraphs #modules
end # module
