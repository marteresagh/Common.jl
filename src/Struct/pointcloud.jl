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
PointCloud(dimension)
```

# Methods
```jldoctest
PointCloud(coordinates,rgbs,normals)
PointCloud(coordinates,rgbs)
PointCloud(coordinates)
PointCloud(dimension)
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
    offset::Point


    function PointCloud(coordinates::Points, rgbs::Points, offset::Point)
        dimension = size(coordinates, 1)
        npoints = size(coordinates, 2)
        normals = reshape([], dimension, 0)
        return new(dimension, npoints, coordinates, rgbs, normals, offset)
    end


    function PointCloud(coordinates::Points, rgbs::Points, normals::Points)
        offset = [0.0, 0.0, 0.0]
        dimension = size(coordinates, 1)
        npoints = size(coordinates, 2)
        @assert dimension == size(normals, 1) "dimension mismatch: points in $(dimension)D space and normals in $(size(normals,1))D space"
        @assert size(coordinates, 2) == size(normals, 2) "length mismatch: $(size(coordinates,2)) points and $(size(normals,2)) normal fields"
        return new(dimension, npoints, coordinates, rgbs, normals, offset)
    end

    function PointCloud(coordinates::Points, rgbs::Points)
        dimension = size(coordinates, 1)
        npoints = size(coordinates, 2)
        offset = [0.0, 0.0, 0.0]
        return new(
            dimension,
            npoints,
            coordinates,
            rgbs,
            reshape([], dimension, 0),
            offset,
        )
    end

    PointCloud(coordinates::Points) = new(
        size(coordinates, 1),
        size(coordinates, 2),
        coordinates,
        reshape([], 3, 0),
        reshape([], size(coordinates, 1), 0),
        [0.0, 0.0, 0.0],
    )
    PointCloud(dimension::Int8) = new(
        dimension,
        0,
        reshape([], Int64(dimension), 0),
        reshape([], 3, 0),
        reshape([], Int64(dimension), 0),
        [0.0, 0.0, 0.0],
    )
    PointCloud() = new(
        0,
        0,
        reshape([], 0, 0),
        reshape([], 0, 0),
        reshape([], 0, 0),
        [0.0, 0.0, 0.0],
    )

end


function add_point!(
    pointcloud::PointCloud,
    position::Point;
    rgb::Point = [],
    normal::Point = [],
)
    pointcloud.coordinates = hcat(pointcloud.coordinates, position)

    @assert !isempty(rgb) || (isempty(rgb) && isempty(pointcloud.rgbs)) "add rgb field to point"
    @assert !isempty(normal) || (isempty(normal) && isempty(pointcloud.normals)) "add normal field to point"

    if !isempty(rgb) && !isempty(pointcloud.rgbs)
        pointcloud.rgbs = hcat(pointcloud.rgbs, rgb)
    end

    if !isempty(normal) && !isempty(pointcloud.normals)
        pointcloud.normals = hcat(pointcloud.normals, normal)
    end

    pointcloud.n_points += 1
    return true
end

function merge_pointcloud(cloud1, cloud2)
    @assert cloud1.dimension == cloud2.dimension "not same dimension"
    positions = hcat(cloud1.coordinates, cloud2.coordinates)

    rgbs = reshape([], 3, 0)
    if !isempty(cloud1.rgbs) && !isempty(cloud2.rgbs)
        rgbs = hcat(cloud1.rgbs, cloud2.rgbs)
    end

    normals = reshape([], Int64(cloud1.dimension), 0)
    if !isempty(cloud1.normals) && !isempty(cloud2.normals)
        hcat(cloud1.normals, cloud2.normals)
    end

    if size(normals, 2) == 0
        return PointCloud(positions, rgbs)
    end

    return PointCloud(positions, rgbs, normals)
end

# #
# function add_normals!(pointcloud::PointCloud, positions::Point; rgbs::Point, normals::Point)
# 	# TODO
# end
