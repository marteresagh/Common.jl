using Common
using Visualization
using FileManager

INPUT_PC = FileManager.source2pc("C:/Users/marte/Documents/GEOWEB/pointcloud_XZ_PLANE_SLICE_AT_QUOTE_15.4525_WITH_THICKNESS_0.05.las",1)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,INPUT_PC.coordinates'),GL.COLORS[2]),
])

points = INPUT_PC.coordinates

# plane fitting
normal, centroid = Common.LinearFit(points)

plane = Plane(normal, centroid)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane.matrix,points)[1:2,:]'),GL.COLORS[2]),
	GL.GLFrame2
])

# PCA
centroid, R = Common.PCA(points)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(Common.matrix4(R),points)[1:2,:]'),GL.COLORS[2]),
	GL.GLFrame2
])
