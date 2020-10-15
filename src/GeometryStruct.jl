"""
PointCloud

struct PointCloud
    n_points
    coordinates
    rgbs
end
"""
struct PointCloud
    n_points::Int64
    coordinates::Lar.Points
    rgbs::Lar.Points

	PointCloud(n_points,coordinates,rgbs) = n_points == size(coordinates,2) == size(rgbs,2) ?  new(n_points,coordinates,rgbs) : error("not consistent")
	PointCloud(coordinates,rgbs) = PointCloud(size(coordinates,2),coordinates,rgbs)
	PointCloud(coordinates) = PointCloud(size(coordinates,2),coordinates,zeros(3,size(coordinates,2)))
	PointCloud() = PointCloud(0,reshape([],0,0),reshape([],0,0))
end

"""
AxisAlignedBoundingBox
"""
mutable struct AABB
    x_max::Float64
    x_min::Float64
    y_max::Float64
    y_min::Float64
    z_max::Float64
    z_min::Float64
end

"""
Dataset for line and plane
"""
mutable struct Hyperplane
	points::PointCloud
    direction::Array{Float64,1}
    centroid::Array{Float64,1}
	Hyperplane(points,direction,centroid) = new(points,direction,centroid)
	Hyperplane(direction,centroid) = new(PointCloud(),direction,centroid)
end
