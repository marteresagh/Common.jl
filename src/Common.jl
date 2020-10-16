__precompile__()

module Common

	using LinearAlgebraicRepresentation
	Lar = LinearAlgebraicRepresentation
	using Delaunay

	# println with flush
    flushprintln(s...) = begin
		println(stdout,s...)
		flush(stdout)
	end

	# include struct
	include("GeometryStruct.jl")

	#include all file .jl in other folders
	folders = ["Geometry"]
	for dir in folders
		for file in readdir(dir)
			
			include(joinpath(dir,file))
			# include("Geometry/distance.jl")
			# include("Geometry/fit.jl")
			# include("Geometry/util.jl")
			# include("Geometry/geometrytools.jl")
			# include("Geometry/delaunay.jl")
		end
	end
	export Lar, PointCloud, Hyperplane, AABB
end # module
