"""
PointCloud

struct PointCloud
    n_points
    coordinates
    rgbs
end
"""
struct PointCloud
	dimension::Int8
    n_points::Int64
    coordinates::Lar.Points
    rgbs::Lar.Points


	PointCloud(coordinates,rgbs) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs)
	PointCloud(coordinates) = new(size(coordinates,1),size(coordinates,2),coordinates,reshape([],0,0))
	PointCloud() = new(0,0,reshape([],0,0),reshape([],0,0))
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
	AABB(x_max, x_min, y_max, y_min, z_max, z_min) = new(x_max, x_min, y_max, y_min, z_max, z_min)
	AABB(x_max, x_min, y_max, y_min) = new(x_max, x_min, y_max, y_min, 0, 0)
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


"""
{
   "scale":{
      "x":1.,
      "y":1.,
      "z":1.
   },
   "position":{
   	  "x":0.,
	  "y":0.,
	  "z":0.
   },
   "rotation":{
      "x":0.,
      "y":0.,
      "z":0.
   },
}
"""
struct Volume
	scale::Array{Float64,1}
	position::Array{Float64,1}
	rotation::Array{Float64,1}
end