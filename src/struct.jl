"""
PointCloud
 - dimension: point cloud dimension,
 - n_points: number of points,
 - coordinates: points position
 - rgbs: points color

# Constructors
```jldoctest
PointCloud(coordinates,rgbs)
PointCloud(coordinates)
PointCloud()
```

# Fields
```jldoctest
dimension	::Int8
n_points	::Int64
coordinates	::Lar.Points
rgbs		::Lar.Points
```
"""
struct PointCloud
	dimension::Int8
    n_points::Int64
    coordinates::Lar.Points
    rgbs::Lar.Points
	normals::Lar.Points

	PointCloud(coordinates,rgbs,normals) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,normals)
	PointCloud(coordinates,rgbs) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,reshape([],0,0))
	PointCloud(coordinates) = new(size(coordinates,1),size(coordinates,2),coordinates,reshape([],0,0))
	PointCloud() = new(0,0,reshape([],0,0),reshape([],0,0),reshape([],0,0))
end

"""
Axis Aligned Bounding Box

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

	# 3D
	AABB(x_max, x_min, y_max, y_min, z_max, z_min) = new(x_max, x_min, y_max, y_min, z_max, z_min)

	# 2D
	AABB(x_max, x_min, y_max, y_min) = new(x_max, x_min, y_max, y_min, 0, 0)
end

"""
Dataset for line and plane
 - inliers:	points on hyperplane
 - direction: versor
 - centroid: point

# Constructors
```jldoctest
Hyperplane(inliers,direction,centroid)
Hyperplane(direction,centroid)
```

# Fields
```jldoctest
inliers		::PointCloud
direction	::Array{Float64,1}
centroid	::Array{Float64,1}
```
"""
mutable struct Hyperplane
	inliers::PointCloud
    direction::Array{Float64,1}
    centroid::Array{Float64,1}

	# with inliers
	Hyperplane(inliers,direction,centroid) = new(inliers,direction,centroid)

	# without inliers
	Hyperplane(direction,centroid) = new(PointCloud(),direction,centroid)
end


"""
Volume
- scale: size of box
- position: position of center
- rotation: Euler angle of rotation

# Fields
```jldoctest
scale	::Array{Float64,1}
position::Array{Float64,1}
rotation::Array{Float64,1}
```
"""
struct Volume
	# size of box
	scale::Array{Float64,1}
	# center of box
	position::Array{Float64,1}
	# Euler angle of rotation of box
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

	# Hessian form
	function Plane(a,b,c,d)
		normal = [a,b,c]
		centroid = normal*d
		rot = Matrix(orthonormal_basis(a,b,c)')
		matrix = Common.matrix4(rot)
		matrix[1:3,4] = centroid
		new(a,b,c,d,matrix)
	end

	# described by two points and an axis orthogonal to normal
	function Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
		axis = (p2-p1)/Lar.norm(p2-p1)
		axis_z = Lar.cross(axis,axis_y)
		@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
		axis_z /= Lar.norm(axis_z)
		axis_x = Lar.cross(axis_y,axis_z)
		axis_x /= Lar.norm(axis_x)

		center_model = Common.centroid(hcat(p1,p2))
		d = Lar.dot(axis_z,center_model)

		rot = [axis_x'; axis_y'; axis_z']
		matrix = Common.matrix4(convert(Matrix,rot'))
		matrix[1:3,4] = p1

		new(axis_z[1], axis_z[2], axis_z[3], d, matrix)
	end

end
