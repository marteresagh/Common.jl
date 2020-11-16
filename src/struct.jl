"""
PointCloud

# Constructors
```jldoctest
PointCloud(coordinates,rgbs)
PointCloud(coordinates)
PointCloud()
```

# Fields
```jldoctest
dimension::Int8
n_points::Int64
coordinates::Lar.Points
rgbs::Lar.Points
```
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

# Constructors
```jldoctest
AABB(x_max, x_min, y_max, y_min, z_max, z_min)
AABB(x_max, x_min, y_max, y_min)
```

# Fields
```jldoctest
x_max::Float64
x_min::Float64
y_max::Float64
y_min::Float64
z_max::Float64
z_min::Float64
```
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

# Constructors
```jldoctest
Hyperplane(points,direction,centroid)
Hyperplane(direction,centroid)
```

# Fields
```jldoctest
inliers::PointCloud
direction::Array{Float64,1}
centroid::Array{Float64,1}
```
"""
mutable struct Hyperplane
	inliers::PointCloud
    direction::Array{Float64,1}
    centroid::Array{Float64,1}
	Hyperplane(inliers,direction,centroid) = new(inliers,direction,centroid)
	Hyperplane(direction,centroid) = new(PointCloud(),direction,centroid)
end


"""
Dataset for line and plane

# Fields
```jldoctest
scale::Array{Float64,1}
position::Array{Float64,1}
rotation::Array{Float64,1}
```
"""
struct Volume
	scale::Array{Float64,1}
	position::Array{Float64,1}
	rotation::Array{Float64,1}
end


"""
Hessian form of plane.

# Constructors
```jldoctest
Plane(a,b,c,d)
Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
```

# Fields
```jldoctest
a::Float64
b::Float64
c::Float64
d::Float64
matrix::Matrix
```
"""
struct Plane
	a::Float64
	b::Float64
	c::Float64
	d::Float64

	matrix::Matrix #matrice da 2D al piano

	function Plane(a,b,c,d)
		normal = [a,b,c]
		centroid = normal*d
		rot = convert(Matrix,hcat(Lar.nullspace(Matrix(normal')),normal)')
		matrix = Common.matrix4(convert(Matrix,rot'))
		matrix[1:3,4] = centroid
		new(a,b,c,d,matrix)
	end

	function Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
		axis = (p2-p1)/Lar.norm(p2-p1)
		axis_z = Lar.cross(axis,axis_y)
		@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
		axis_z /= Lar.norm(axis_z)

		center_model = Common.centroid(hcat(p1,p2))
		d = Lar.dot(axis_z,center_model)
		Plane(axis_z[1], axis_z[2], axis_z[3], d)

	end
end
