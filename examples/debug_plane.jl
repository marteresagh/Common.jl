using Common
using FileManager
source = raw"C:\Users\marte\Documents\GEOWEB\profile.las"
output_folder = raw"C:\Users\marte\Documents\GEOWEB\TEST"
lod = -1

PC = FileManager.source2pc(source, lod)

header, lasPoints = FileManager.read_LAS_LAZ(source)
# plane description
direction, centroid = Common.LinearFit(PC.coordinates)
plane = Common.Plane(direction,centroid)

io = open(joinpath(output_folder,"planeCoeff.csv"),"w")
write(io, "$(plane.a) $(plane.b) $(plane.c) $(plane.d)")
close(io)

FileManager.successful(true, output_folder)
