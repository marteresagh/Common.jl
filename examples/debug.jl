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

plane1 = Plane(normal, centroid)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1]),
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane1.matrix,points)'),GL.COLORS[4]),
	GL.GLFrame
])

# PCA

plane2 = Plane(points)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1]),
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane2.matrix,points)'),GL.COLORS[4]),
	GL.GLFrame
])
