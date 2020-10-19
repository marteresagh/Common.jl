"""
Apply affine transformation to points V.
"""
function apply_matrix(affineMatrix, V)
	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	T = (affineMatrix * W)[1:m,1:n]
	return T
end


"""
Average of points.
"""
centroid(points::Union{Lar.Points,Array{Float64,1}}) = (sum(points,dims=2)/size(points,2))[:,1]


function return_AABB(aabb)
	#aabb = ([x_min,y_min,z_min],[x_max,y_max,z_max])
	bb = [[a,b]  for (a,b) in zip(aabb[2],aabb[1])]
	return AABB(vcat(bb...)...)
end

"""
Axis aligned bounding box
"""
function boundingbox(points::Lar.Points)::AABB
	bb = Lar.boundingbox(points)
	return return_AABB(bb)
end

"""
Compute the average of the data points and traslate data.
"""
function subtractaverage(points::Lar.Points)
	m,npoints = size(points)
	c = centroid(points)
	affineMatrix = Lar.t(-c...)
	V = [points; fill(1.0, (1,npoints))]
	Y = (affineMatrix * V)[1:m,1:npoints]
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
Check if point is in a aabb
"""
function isinbox(aabb,p)
	min=aabb[1]
	max=aabb[2]
	return (  p[1]>=min[1] && p[1]<=max[1] &&
			  p[2]>=min[2] && p[2]<=max[2] &&
			   p[3]>=min[3] && p[3]<=max[3] )
end



"""
Matrix 2 euler
"""
function matrix2euler(rotation)
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
