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
coordinates	::Lar.Points
rgbs		::Lar.Points
```
"""
mutable struct PointCloud
	dimension::Int8
    n_points::Int64
    coordinates::Lar.Points
    rgbs::Lar.Points
	normals::Lar.Points

	PointCloud(coordinates,rgbs,normals) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,normals)
	PointCloud(coordinates,rgbs) = new(size(coordinates,1),size(coordinates,2),coordinates,rgbs,reshape([],0,0))
	PointCloud(coordinates) = new(size(coordinates,1),size(coordinates,2),coordinates,reshape([],0,0),reshape([],0,0))
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
Dataset for hypersphere
 - inliers:	points on hypersphere
 - center: center of hypersphere
 - radius: radius of hypersphere

# Constructors
```jldoctest
Hypersphere(inliers,center,radius) = new(inliers,center,radius)
Hypersphere(center,radius) = new(PointCloud(),center,radius)
```

# Fields
```jldoctest
inliers		::PointCloud
center		::Array{Float64,1}
radius		::Float64
```
"""
mutable struct Hypersphere
	inliers::PointCloud
    center::Array{Float64,1}
	radius::Float64

	# with inliers
	Hypersphere(inliers,center,radius) = new(inliers,center,radius)

	# without inliers
	Hypersphere(center,radius) = new(PointCloud(),center,radius)
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
	# Euler angles of box
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

	normal::Array{Float64,1}
	centroid::Array{Float64,1}

	matrix::Matrix #::Matrix4 rototraslazione dal piano al piano cartesiano 2D
	basis::Matrix #::Matrix3 base del piano

	# Hessian form
	function Plane(normal::Array{Float64,1},centroid::Array{Float64,1})
		normal /= Lar.norm(normal)
		a,b,c = normal
		d = Lar.dot(normal,centroid)
		basis = Common.orthonormal_basis(normal...)
		rot = Lar.inv(basis)
		matrix = Common.matrix4(rot)
		matrix[1:3,4] = Common.apply_matrix(matrix,-centroid)
		new(a, b, c, d, normal, centroid, matrix, basis)
	end


	function Plane(a,b,c,d)
		normal = [a,b,c]
		normal /= Lar.norm(normal)
		centroid = [a,b,c]*d
		basis = orthonormal_basis(normal...)
		rot = Lar.inv(basis)
		matrix = Common.matrix4(rot)
		matrix[1:3,4] = Common.apply_matrix(matrix,-centroid)
		new(a, b, c, d, normal, centroid, matrix, basis)
	end

	# described by two points and an axis orthogonal to normal
	function Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
		basis = orthonormal_basis(p1, p2, axis_y)
		axis_z = basis[:,3]

		center_model = Common.centroid(hcat(p1,p2))
		d = Lar.dot(axis_z,center_model)

		rot = Lar.inv(basis)
		matrix = Common.matrix4(convert(Matrix,rot))
		matrix[1:3,4] = Common.apply_matrix(matrix,-p1)

		new(axis_z[1], axis_z[2], axis_z[3], d,[axis_z[1], axis_z[2], axis_z[3]],center_model, matrix, basis)
	end

	function Plane(volume::Volume)
		basis = Common.euler2matrix(volume.rotation...)
		axis_z = basis[:,3]
		matrix = Common.matrix4(convert(Matrix,basis'))
		matrix[1:3,4] = Common.apply_matrix(matrix,-volume.position)
		new(axis_z[1], axis_z[2], axis_z[3], Lar.dot(axis_z,volume.position),[axis_z[1], axis_z[2], axis_z[3]],volume.position, matrix, basis)
	end

	function Plane(points::Lar.Points)
		centroid, basis = Common.PCA(points)
		rot = Lar.inv(basis)
		matrix = Common.matrix4(rot)
		matrix[1:3,4] = Common.apply_matrix(matrix,-centroid)
		new(basis[1,3],basis[2,3],basis[3,3], Lar.dot(centroid,basis[:,3]),[basis[1,3],basis[2,3],basis[3,3]], centroid, matrix, basis)
	end

end
