"""
	matrix2euler(rotation::Matrix)

Matrix to euler in XYZ order.
"""
function matrix2euler(rotation::Matrix)
	# rotation 3x3
	y = Lar.asin( clamp( rotation[1,3], - 1, 1 ) )

	if ( Lar.abs( rotation[1,3] ) < 0.9999999 )

		x = Lar.atan( - rotation[2,3], rotation[3,3] )
		z = Lar.atan( - rotation[1,2], rotation[1,1] )

	 else

		x = Lar.atan( rotation[3,2], rotation[2,2] )
		z = 0

	end

	return [x,y,z]
end


"""
	euler2matrix(x::Float64,y::Float64,z::Float64)

Euler to matrix.
"""
function euler2matrix(x::Float64,y::Float64,z::Float64)

		M = Matrix{Float64}(Lar.I,3,3)

		a = Lar.cos( x )
		b = Lar.sin( x )
		c = Lar.cos( y )
		d = Lar.sin( y )
		e = Lar.cos( z )
		f = Lar.sin( z )

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
vec1: A 3d "source" vector,
vec2: A 3d "reference" vector,
Return affine transformation matrix (4x4) which when applied to vec1, aligns it with vec2.
"""
function vectors2rotation(vec_source, vec_ref)
	#alcuni spunti
	#https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
    v = Lar.cross(vec_source, vec_ref)
    c = Lar.dot(vec_source, vec_ref)
    s = Lar.norm(v)
    kmat = [0 -v[3] v[2]; v[3] 0 -v[1]; -v[2] v[1] 0]
    rotation_matrix = Matrix(Lar.I,3,3) + kmat + kmat^2* ((1 - c) / (s ^ 2))
    return rotation_matrix
end


"""
matrix of rotation
"""
function box_new_coords_system(model)
	verts,edges,faces = model
	axis_x = (verts[:,5]-verts[:,1])/Lar.norm(verts[:,5]-verts[:,1])
	axis_y = (verts[:,3]-verts[:,1])/Lar.norm(verts[:,3]-verts[:,1])
	axis_z = (verts[:,2]-verts[:,1])/Lar.norm(verts[:,2]-verts[:,1])
	#coordsystem = [axis_x';axis_y';axis_z']
	return [axis_x';axis_y';axis_z']
end


# function rotoTraslation(planesource,planeref)
# 	axref, centref = planeref
# 	axsour, centsour = planesource
# 	rotation_matrix = PointClouds.euler_matrix_from_vectors(axref,axsour)
#
# 	rototrasl = Lar.t(centref...)*rotation_matrix'*Lar.t(-centsour...)
# 	return rototrasl
# end
#
# function alignbox2plane(pointofplane::Lar.Points, boxmodel)
# 	planeref = PointClouds.planefit(pointofplane)
# 	V, EV, FV = boxmodel
# 	planesource = PointClouds.planefit(V)
# 	return PointClouds.rotoTraslation(planesource,planeref)
# end
