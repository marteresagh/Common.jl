__precompile__()

module Common

	using LinearAlgebraicRepresentation
	Lar = LinearAlgebraicRepresentation

	using NearestNeighbors
	using Delaunay
	using Statistics

	using Base.Cartesian
	import Base.Prehashed

	# println with flush
	flushprintln(s...) = begin
		println(stdout,s...)
		flush(stdout)
	end

	# include struct
	include("struct.jl")
	include("keyboard_event.jl")

	#include all file .jl in other folders
	include("Geometry/distance.jl")
	include("Geometry/fit.jl")
	include("Geometry/util.jl")
	include("Geometry/geometrytools.jl")
	include("Geometry/delaunay.jl")
	include("Geometry/intersect_model.jl")
	include("Geometry/volume.jl")
	include("Geometry/neighbors.jl")
	include("Geometry/outliers.jl")
	include("Geometry/double_verts.jl")

	export  PointCloud, Hyperplane, AABB, Volume, Plane, #structs
			monitorInput, flushprintln, getmodel, #funs
			NearestNeighbors, Statistics, Lar #modules
end # module
