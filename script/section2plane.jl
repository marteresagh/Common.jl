println("loading packages... ")

using ArgParse
using Common
using FileManager

println("packages OK")

function parse_commandline()
	s = ArgParseSettings()

	@add_arg_table! s begin
	"source"
		help = "Potree project or .las file"
		required = true
	"--output", "-o"
		help = "Output folder"
		required = true
	"--lod"
		help = "Level of detail. If -1, all points are taken"
		arg_type = Int64
		default = -1
	end

	return parse_args(s)
end

function main()
	args = parse_commandline()

	source = args["source"]
	output_folder = args["output"]
	lod = args["lod"]

	PC = FileManager.source2pc(source, lod)

	# plane description
	try
		direction, centroid = Common.LinearFit(PC.coordinates)
		plane = Common.Plane(direction,centroid)

		io = open(joinpath(output_folder,"planeCoeff.csv"),"w")
		write(io, "$(plane.a) $(plane.b) $(plane.c) $(plane.d)")
		close(io)

		FileManager.successful(true, output_folder)
	catch y

	end

end

@time main()
