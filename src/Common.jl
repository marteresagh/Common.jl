__precompile__()

module Common

	using LinearAlgebraicRepresentation
	Lar = LinearAlgebraicRepresentation

	using NearestNeighbors

	# println with flush
	flushprintln(s...) = begin
		println(stdout,s...)
		flush(stdout)
	end

	# include struct
	include("GeometryStruct.jl")

	#include all file .jl in other folders
	include("Geometry/distance.jl")
	include("Geometry/fit.jl")
	include("Geometry/util.jl")
	include("Geometry/geometrytools.jl")
	include("Geometry/delaunay.jl")
	include("Geometry/intersect_model.jl")
	include("Geometry/volume.jl")
	include("Geometry/neighbors.jl")

	export Lar, PointCloud, Hyperplane, AABB, Volume, flushprintln, getmodel
end # module
