"""
matrice orlata
"""
function matrix4(m::Matrix)
	return vcat(hcat(m,[0,0,0]),[0.,0.,0.,1.]')
end

"""
apply_matrix(affineMatrix::Matrix, V::Lar.Points) -> Lar.Points

Apply affine transformation `affineMatrix` to points `V`.
"""
function apply_matrix(affineMatrix::Matrix, V::Lar.Points)
	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	T = (affineMatrix * W)[1:m,1:n]
	return T
end

function apply_matrix(affineMatrix, V::Array{Float64,1})
	T = reshape(V,3,1)
	return apply_matrix(affineMatrix, T)
end

"""
Create orthonormal basis from a given vector `a,b,c`.
"""
function orthonormal_basis(a,b,c)
	w = [a, b, c]
	v = [c, 0, a]
	u = Lar.cross(v,w)

	u /= Lar.norm(u)
	v /= Lar.norm(v)
	w /= Lar.norm(w)
	return [u';v';w'] # by row
end

"""
matrix of rotation
"""
function box_new_coords_system(model)
	verts,edges,faces = model
	axis_x = (verts[:,5]-verts[:,1])/Lar.norm(verts[:,5]-verts[:,1])
	axis_y = (verts[:,2]-verts[:,1])/Lar.norm(verts[:,2]-verts[:,1])
	axis_z = (verts[:,3]-verts[:,1])/Lar.norm(verts[:,3]-verts[:,1])
	#coordsystem = [axis_x';axis_y';axis_z']
	return [axis_x';axis_y';axis_z']
end

"""
centroid(points::Lar.points)

Average of points.
"""
centroid(points::Union{Lar.Points,Array{Float64,1}}) = (sum(points,dims=2)/size(points,2))[:,1]

"""
AABB
"""
function return_AABB(aabb)
	#aabb = ([x_min,y_min,z_min],[x_max,y_max,z_max])
	bb = [[a,b]  for (a,b) in zip(aabb[2],aabb[1])]
	return AABB(vcat(bb...)...)
end

"""
boundingbox(points::Lar.Points) -> AABB
Axis aligned bounding box
"""
function boundingbox(points::Lar.Points)::AABB
	a = [extrema(points[i,:]) for i in 1:size(points,1)]
	b = reverse.(a)
	return AABB(collect(Iterators.flatten(b))...)
end

"""
Compute the average of the data points and traslate data.
"""
function subtractaverage(points::Lar.Points)
	m,npoints = size(points)
	c = centroid(points)
	affineMatrix = Lar.t(-c...)
	Y = apply_matrix(affineMatrix,points)
	return c,Y
end


"""
	matchcolumn(a,B)

Finds index column of `a` in matrix `B`.
Returns `nothing` if `a` is not column of `B`.
"""
matchcolumn(a,B) = findfirst(j->all(i->a[i] == B[i,j],1:size(B,1)),1:size(B,2))

# """
#
# """
# function height(direction:: Array{Float64,1}, V::Lar.Points)
# 	hmin = +Inf
# 	hmax = -Inf
#
# 	for i in 1:size(V,2)
# 		h = Lar.dot(direction,V[:,i])
# 		if h > hmax
# 			hmax = h
# 		elseif h < hmin
# 			hmin = h
# 		end
# 	end
#
# 	return hmax-hmin
# end

"""
 	CAT(args)
"""
function CAT(args)
	return reduce( (x,y) -> append!(x,y), args; init=[] )
end

"""
isinbox(aabb,p)

Check if point `p` is in a `aabb `.
"""
function isinbox(aabb::AABB,p::Array{Float64,1})
	return (  p[1]>=aabb.x_min && p[1]<=aabb.x_max &&
			  p[2]>=aabb.y_min && p[2]<=aabb.y_max &&
			   p[3]>=aabb.z_min && p[3]<=aabb.z_max )
end


"""
matrix2euler(rotation::Matrix)

Matrix to euler in XYZ order
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
function rotation_matrix_from_vectors(vec1, vec2)
	#alcuni spunti
	#https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
    v = Lar.cross(vec1, vec2)
    c = Lar.dot(vec1, vec2)
    s = Lar.norm(v)
    kmat = [0 -v[3] v[2]; v[3] 0 -v[1]; -v[2] v[1] 0]
    rotation_matrix = Matrix(Lar.I,3,3) + kmat + kmat^2* ((1 - c) / (s ^ 2))
    return vcat(hcat(rotation_matrix,[0,0,0]),[0.,0.,0.,1.]')
end


# function rotoTraslation(planesource,planeref)
# 	axref, centref = planeref
# 	axsour, centsour = planesource
# 	rotation_matrix = PointClouds.rotation_matrix_from_vectors(axref,axsour)
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
