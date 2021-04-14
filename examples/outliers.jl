using Common
using Visualization
using FileManager

source = "examples/las/polyline.las"
PC = FileManager.las2pointcloud(source)
PC2D = PointCloud(PC.coordinates[1:2,:])
k = 10
outliers = Common.outliers(PC2D, [1:PC2D.n_points...], k)
tofit = setdiff([1:PC2D.n_points...], outliers)

# dirty points
GL.VIEW([
	Visualization.points(PC2D.coordinates; color = GL.COLORS[12]),
])

# outliers in red
GL.VIEW([
	Visualization.points(PC2D.coordinates[:,tofit]; color = GL.COLORS[12]),
	Visualization.points(PC2D.coordinates[:,outliers];color = GL.COLORS[2]),
])

# points without outliers
GL.VIEW([
	Visualization.points(PC2D.coordinates[:,tofit]; color = GL.COLORS[12]),
])
