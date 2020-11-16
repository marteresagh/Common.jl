using Common
using Visualization
using FileManager

source = "examples/muriAngolo.las"
PC = FileManager.las2pointcloud(source)
PC2D = PointCloud(PC.coordinates[1:2,:])
k = 10
outliers = Common.outliers(PC2D, [1:PC2D.n_points...], k)
tofit = setdiff([1:PC2D.n_points...], outliers)

GL.VIEW([
			GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,tofit]'),GL.COLORS[12]),
			GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,outliers]'),GL.COLORS[2]),

])
