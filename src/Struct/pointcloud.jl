"""
	Points, Point -> Matrix, Vector

Dense Matrix ``M x N`` to store the position of *vertices*. The number of rows ``M`` is the dimension
of the embedding space. The number of columns ``N`` is the number of vertices.
A single Point is described as a Vector of length ``M``.
"""
const Points = Matrix # a single point is a Vector
const Point = Vector # a single point is a Vector

"""
PointCloud
 - dimension: point cloud dimension,
 - n_points: number of points,
 - coordinates: points position
 - rgbs: points color
 - normals: normal of points

# Constructors
```jldoctest
PointCloud(coordinates,rgbs,normals)
PointCloud(coordinates,rgbs)
PointCloud(coordinates)
PointCloud()
```

# Fields
```jldoctest
dimension	::Int8
n_points	::Int64
coordinates	::Points
rgbs		::Points
normals		::Points
```
"""
mutable struct PointCloud
	dimension::Int8
    n_points::Int64
    coordinates::Points
    rgbs::Points
	normals::Points

	PointCloud(coordinates,rgbs,normals) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,normals)
	PointCloud(coordinates,rgbs) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,reshape([],0,0))
	PointCloud(coordinates) = new(size(coordinates,1),size(coordinates,2),coordinates,reshape([],0,0),reshape([],0,0))
	PointCloud() = new(0,0,reshape([],0,0),reshape([],0,0),reshape([],0,0))
end

function add(pointcloud::PointCloud, position::Point, rgb::Point, normal::Point)
	# TODO
end
