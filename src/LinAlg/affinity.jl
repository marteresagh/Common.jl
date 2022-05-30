"""
	t(args::Array{Number,1}...)::Matrix

Return an *affine transformation Matrix* in homogeneous coordinates. Such `translation` Matrix has ``d+1`` rows and ``d+1`` columns, where ``d`` is the number of translation parameters in the `args` array.
"""
function t(args...)::Matrix
	d = length(args)
	mat = Matrix{Float64}(LinearAlgebra.I, d+1, d+1)
	for k in range(1, length=d)
        	mat[k,d+1]=args[k]
	end
	return mat
end

"""
	s(args::Array{Number,1}...)::Matrix


Return an *affine transformation Matrix* in homogeneous coordinates. Such `scaling` Matrix has ``d+1`` rows and ``d+1`` columns, where ``d`` is the number of scaling parameters in the `args` array.
"""
function s(args...)::Matrix
	d = length(args)
	mat = Matrix{Float64}(LinearAlgebra.I, d+1, d+1)
	for k in range(1, length=d)
		mat[k,k]=args[k]
	end
	return mat
end

"""
	r(args...)::Matrix

Return an *affine transformation Matrix* in homogeneous coordinates. Such `Rotation` Matrix has *dimension* either equal to 3 or to 4, for 2D and 3D rotation, respectively.
The `{Number,1}` of `args` either contain a single `angle` parameter in *radiants*, or a vector with three elements, whose `norm` is the *rotation angle* in 3D and whose `normalized value` gives the direction of the *rotation axis* in 3D.
"""
function r(args...)::Matrix
    args = collect(args)
    n = length(args)
    if n == 1 # rotation in 2D
        angle = args[1]; COS = cos(angle); SIN = sin(angle)
        mat = Matrix{Float64}(LinearAlgebra.I, 3, 3)
        mat[1,1] = COS;    mat[1,2] = -SIN;
        mat[2,1] = SIN;    mat[2,2] = COS;
    end

     if n == 3 # rotation in 3D
        mat = Matrix{Float64}(LinearAlgebra.I, 4, 4)
        angle = norm(args);
        if norm(args) != 0.0
			axis = args #normalize(args)
			COS = cos(angle); SIN= sin(angle)
			if axis[2]==axis[3]==0.0    # rotation about x
				mat[2,2] = COS;    mat[2,3] = -SIN;
				mat[3,2] = SIN;    mat[3,3] = COS;
			elseif axis[1]==axis[3]==0.0   # rotation about y
				mat[1,1] = COS;    mat[1,3] = SIN;
				mat[3,1] = -SIN;    mat[3,3] = COS;
			elseif axis[1]==axis[2]==0.0    # rotation about z
				mat[1,1] = COS;    mat[1,2] = -SIN;
				mat[2,1] = SIN;    mat[2,2] = COS;
			else
				I = Matrix{Float64}(LinearAlgebra.I, 3, 3); u = axis
				Ux=[0 -u[3] u[2] ; u[3] 0 -u[1] ;  -u[2] u[1] 1]
				UU =[u[1]*u[1]    u[1]*u[2]   u[1]*u[3];
					 u[2]*u[1]    u[2]*u[2]   u[2]*u[3];
					 u[3]*u[1]    u[3]*u[2]   u[3]*u[3]]
				mat[1:3,1:3]=COS*I+SIN*Ux+(1.0-COS)*UU
			end
		end
	end
	return mat
end


"""
	matrix2euler(rotation::Matrix)

Matrix to euler in XYZ order.
"""
function matrix2euler(rotation::Matrix)
	# rotation 3x3
	y = LinearAlgebra.asin( clamp( rotation[1,3], - 1, 1 ) )

	if ( LinearAlgebra.abs( rotation[1,3] ) < 0.9999999 )

		x = LinearAlgebra.atan( - rotation[2,3], rotation[3,3] )
		z = LinearAlgebra.atan( - rotation[1,2], rotation[1,1] )

	 else

		x = LinearAlgebra.atan( rotation[3,2], rotation[2,2] )
		z = 0

	end

	return [x,y,z]
end


"""
	euler2matrix(x::Float64,y::Float64,z::Float64)

Euler to matrix in XYZ order.
"""
function euler2matrix(x::Float64,y::Float64,z::Float64)

	M = Matrix{Float64}(LinearAlgebra.I,3,3)

	a = LinearAlgebra.cos( x )
	b = LinearAlgebra.sin( x )
	c = LinearAlgebra.cos( y )
	d = LinearAlgebra.sin( y )
	e = LinearAlgebra.cos( z )
	f = LinearAlgebra.sin( z )

	ae = a * e
	af = a * f
	be = b * e
	bf = b * f

	M[1,1] = c * e
	M[1,2] = - c * f
	M[1,3] = d

	M[2,1] = af + be * d
	M[2,2] = ae - bf * d
	M[2,3] = - b * c

	M[ 3,1 ] = bf - ae * d
	M[ 3,2 ] = be + af * d
	M[ 3,3 ] = a * c

	return M
end


"""
Find the rotation matrix that aligns vec1 to vec2
vec1: A 3d "source" vector, (moved)
vec2: A 3d "reference" vector, (fixed)
Return affine transformation matrix (4x4) which when applied to vec1, aligns it with vec2.
"""
function vectors2rotation(vec_source, vec_ref)
	#alcuni spunti
	#https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
    v = LinearAlgebra.cross(vec_source, vec_ref)
    c = LinearAlgebra.dot(vec_source, vec_ref)
    s = LinearAlgebra.norm(v)
    kmat = [0 -v[3] v[2]; v[3] 0 -v[1]; -v[2] v[1] 0]
    rotation_matrix = Matrix(LinearAlgebra.I,3,3) + kmat + kmat^2* ((1 - c) / (s ^ 2))
    return rotation_matrix
end


"""
matrix of rotation
"""
function box_new_coords_system(model)
	verts,edges,faces = model
	axis_x = (verts[:,5]-verts[:,1])/LinearAlgebra.norm(verts[:,5]-verts[:,1])
	axis_y = (verts[:,3]-verts[:,1])/LinearAlgebra.norm(verts[:,3]-verts[:,1])
	axis_z = (verts[:,2]-verts[:,1])/LinearAlgebra.norm(verts[:,2]-verts[:,1])
	#coordsystem = [axis_x';axis_y';axis_z']
	return [axis_x';axis_y';axis_z']
end


"""
	orthonormal_basis(a,b,c)

Create orthonormal basis from a given vector `a,b,c`.
"""
function orthonormal_basis(a,b,c)
	# https://www.mathworks.com/matlabcentral/answers/72631-create-orthonormal-basis-from-a-given-vector
	w = [a, b, c]

	if a == 0. && c == 0.
		v = [0,-c,b]
	else
		v = [-c, 0, a]
	end

	u = LinearAlgebra.cross(v,w)

	# @assert LinearAlgebra.dot(w,v) ≈ 0. "Dot product = $(LinearAlgebra.dot(w,v))"
	# @assert LinearAlgebra.dot(w,u) ≈ 0. "Dot product = $(LinearAlgebra.dot(w,u))"
	# @assert LinearAlgebra.dot(u,v) ≈ 0. "Dot product = $(LinearAlgebra.dot(u,v))"

	u /= LinearAlgebra.norm(u)
	v /= LinearAlgebra.norm(v)
	w /= LinearAlgebra.norm(w)
	return hcat(u,v,w) # by column
end


function orthonormal_basis(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
	axis = (p2-p1)/LinearAlgebra.norm(p2-p1)
	axis_y /= LinearAlgebra.norm(axis_y)
	axis_z = LinearAlgebra.cross(axis,axis_y)
	@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
	axis_z /= LinearAlgebra.norm(axis_z)
	axis_x = LinearAlgebra.cross(axis_y,axis_z)
	axis_x /= LinearAlgebra.norm(axis_x)

	rot = hcat(axis_x, axis_y, axis_z)

	if LinearAlgebra.det(rot)<0
		rot[:,3] = -rot[:,3]
	end
	return rot
end

# function rotoTraslation(planesource,planeref)
# 	axref, centref = planeref
# 	axsour, centsour = planesource
# 	rotation_matrix = PointClouds.euler_matrix_from_vectors(axref,axsour)
#
# 	rototrasl = Common.t(centref...)*rotation_matrix'*Geometry.t(-centsour...)
# 	return rototrasl
# end
#
# function alignbox2plane(pointofplane::Points, boxmodel)
# 	planeref = PointClouds.planefit(pointofplane)
# 	V, EV, FV = boxmodel
# 	planesource = PointClouds.planefit(V)
# 	return PointClouds.rotoTraslation(planesource,planeref)
# end
