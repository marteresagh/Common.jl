using Common
using FileManager

points = rand(3,100)

rgb = rand(3,100)

pc = PointCloud(points, convert(Matrix{FileManager.LasIO.N0f16}, rgb))

FileManager.save_pointcloud(raw"D:\pointclouds\test.las",pc, "test")
