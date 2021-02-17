__precompile__()

module Common

	using LinearAlgebraicRepresentation
	Lar = LinearAlgebraicRepresentation
	using SparseArrays

	using LightGraphs
	using NearestNeighbors

	using Delaunay
	using QHull

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
	include("Features/density.jl")
	include("Features/double_verts.jl")
	include("Features/estimation.jl")
	include("Features/neighbors.jl")
	# geometry
	include("Geometry/boundingbox.jl")
	include("Geometry/delaunay.jl")
	include("Geometry/fit.jl")
	include("Geometry/residual.jl")
	include("Geometry/rotations.jl")
	include("Geometry/tools.jl")
	include("Geometry/util.jl")
	# graph
	include("Graph/boundary.jl")
	include("Graph/graph.jl")
	# model
	include("Model/getmodel.jl")
	include("Model/intersection.jl")

	export  PointCloud, Hyperplane, AABB, Volume, Plane, Hypersphere, #structs
			monitorInput, flushprintln, getmodel, #funs
			NearestNeighbors, Statistics, Lar, LightGraphs #modules
end # module
