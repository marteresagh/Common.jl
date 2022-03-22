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

	AABB() = new(-Inf, Inf, -Inf, Inf, -Inf, Inf)

	function AABB(points::Points)
		dim = size(points,1)
		a = [extrema(points[i,:]) for i in 1:dim]
		if dim == 2
			return AABB(a[1][2],a[1][1],a[2][2],a[2][1])
		else
			return AABB(a[1][2],a[1][1],a[2][2],a[2][1],a[3][2],a[3][1])
		end
	end
end


function Base.show(io::IO, aabb::Common.AABB)
    println(io, "min: [$(aabb.x_min),$(aabb.y_min),$(aabb.z_min)]")
	println(io, "max: [$(aabb.x_max),$(aabb.y_max),$(aabb.z_max)]")
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

	#METODI TODO
end


"""
Plane object.

# Constructors
```jldoctest
Plane(a,b,c,d)
Plane(normal::Array{Float64,1},centroid::Array{Float64,1})
Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
Plane(points::Points)
```

# Fields
```jldoctest
a::Float64
b::Float64
c::Float64
d::Float64

normal::Array{Float64,1}
centroid::Array{Float64,1}

matrix::Matrix #::Matrix4 rototraslazione dal piano al piano cartesiano 2D
basis::Matrix #::Matrix3 base del piano
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
		normal /= LinearAlgebra.norm(normal)
		a,b,c = normal
		d = LinearAlgebra.dot(normal,centroid)
		basis = orthonormal_basis(normal...)
		rot = LinearAlgebra.inv(basis)
		matrix = matrix4(rot)
		matrix[1:3,4] = rot*-centroid #apply_matrix(matrix,-centroid)
		new(a, b, c, d, normal, centroid, matrix, basis)
	end

	function Plane(a,b,c,d)
		normal = [a,b,c]
		normal /= LinearAlgebra.norm(normal)
		centroid = [a,b,c]*d
		basis = orthonormal_basis(normal...)
		rot = LinearAlgebra.inv(basis)
		matrix = matrix4(rot)
		matrix[1:3,4] = rot*-centroid #apply_matrix(matrix,-centroid)
		new(a, b, c, d, normal, centroid, matrix, basis)
	end

	# described by two points and an axis orthogonal to normal
	function Plane(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
		basis = orthonormal_basis(p1, p2, axis_y)
		axis_z = basis[:,3]

		center_model = centroid(hcat(p1,p2))
		d = LinearAlgebra.dot(axis_z,center_model)

		rot = LinearAlgebra.inv(basis)
		matrix = matrix4(rot)
		matrix[1:3,4] = rot*-p1 #apply_matrix(matrix,-centroid)

		new(axis_z[1], axis_z[2], axis_z[3], d,[axis_z[1], axis_z[2], axis_z[3]],center_model, matrix, basis)
	end

	function Plane(volume::Volume)
		basis = euler2matrix(volume.rotation...)
		axis_z = basis[:,3]
		rot = permutedims(basis)
		matrix = matrix4(rot)
		matrix[1:3,4] = rot*-volume.position #apply_matrix(matrix,-centroid)
		# matrix[1:3,4] = apply_matrix(matrix,-volume.position)
		new(axis_z[1], axis_z[2], axis_z[3], LinearAlgebra.dot(axis_z,volume.position),[axis_z[1], axis_z[2], axis_z[3]],volume.position, matrix, basis)
	end

	function Plane(points::Points)
		centroid, basis = PCA(points)
		rot = LinearAlgebra.inv(basis)
	 	matrix = matrix4(rot)
		matrix[1:3,4] = rot*-centroid #apply_matrix(matrix,-centroid)
		new(basis[1,3],basis[2,3],basis[3,3], LinearAlgebra.dot(centroid,basis[:,3]),[basis[1,3],basis[2,3],basis[3,3]], centroid, matrix, basis)
	end

end


"""
Line object.

# Constructors
```jldoctest
Line(startPoint::Point,endPoint::Point)
Line(startPoint::Point,direction::Array{Float64,1},len::Float64)
Line(points::Points)
```

# Fields
```jldoctest
startPoint::Point
endPoint::Point
direction::Array{Float64,1}
```
"""
struct Line
	startPoint::Point
	endPoint::Point
	direction::Array{Float64,1}

	function Line(startPoint::Point,endPoint::Point)
		direction = endPoint-startPoint
		direction /= LinearAlgebra.norm(direction)
		new(startPoint,endPoint,direction)
	end

	function Line(startPoint::Point,direction::Array{Float64,1},len)
		endPoint = startPoint+len*direction
		new(startPoint,endPoint,direction)
	end

	function Line(points::Points)
		direction,centroid = Fit_Line(points)
		max_value = -Inf
		min_value = +Inf
		for i in 1:size(points,2)
			p = points[:,i] - centroid
			value = LinearAlgebra.dot(direction,p)
			if value > max_value
				max_value = value
			end
			if value < min_value
				min_value = value
			end
		end
		startPoint = centroid + (min_value)*direction
		endPoint = centroid + (max_value)*direction
		new(startPoint,endPoint,direction)
	end

end
