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
	# dirs = readdir("src")
	# for dir in dirs
	# 	name = joinpath("src",dir)
    # 	if isdir(name)
	# 		for (root,folders,files) in walkdir(name)
	# 			for file in files
	# 				head = splitdir(root)[2]
	# 			 	include(joinpath(head,file))
	# 			end
	# 		end
	# 	end
	# end

	include("Geometry/distance.jl")
	include("Geometry/fit.jl")
	include("Geometry/util.jl")
	export Lar, PointCloud, Hyperplane, AABB
end # module
