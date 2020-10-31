using Common
using Visualization
using FileManager

source = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCONTEA\\Sezione_z650.las"
source = "examples\\muriAngolo.las"
PC = FileManager.las2pointcloud(source)
PC2D = PointCloud(PC.coordinates[1:2,:])
k = 10
outliers = Common.outliers(PC2D, [1:PC2D.n_points...], k)
tofit = setdiff([1:PC2D.n_points...],outliers)

plane= Common.Plane(0,0,1,6.5)
INPUT_PC = PointCloud(Common.apply_matrix(plane.matrix',PC.coordinates), PC.rgbs)

GL.VIEW([
			GL.GLPoints(convert(Lar.Points,INPUT_PC.coordinates'),GL.COLORS[12]),
			GL.GLFrame2
			#GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,outliers]'),GL.COLORS[2]),

])

GL.VIEW([
			GL.GLPoints(convert(Lar.Points,PC2D.coordinates'),GL.COLORS[12]),
			#GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,outliers]'),GL.COLORS[2]),

])
