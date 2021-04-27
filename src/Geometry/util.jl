"""
Orla la matrice
"""
function matrix4(m::Matrix)
	return vcat(hcat(m,[0,0,0]),[0.,0.,0.,1.]')
end

function matrix3(m::Matrix)
	return vcat(hcat(m,[0,0]),[0.,0.,1.]')
end

"""
	apply_matrix(affineMatrix::Matrix, V::Points) -> Points

Apply affine transformation `affineMatrix` to points `V`.
"""
function apply_matrix(affineMatrix::Matrix, V::Points)
	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	T = (affineMatrix * W)[1:m,1:n]
	return T
end

function apply_matrix(affineMatrix::Matrix, V::Point)
	T = reshape(V,length(V),1)
	return apply_matrix(affineMatrix, T)
end

"""
	centroid(points::Points)

Average of points.
"""
@inline centroid(points::Points) = (sum(points,dims=2)/size(points,2))[:,1]

"""
	subtractaverage(points::Points)

Compute the average of the data points and traslate data.
Return vector of traslation and new data.
"""
function subtractaverage(points::Points)
	m,npoints = size(points)
	c = centroid(points)
	affineMatrix = Geometry.t(-c...)
	Y = apply_matrix(affineMatrix,points)
	return c,Y
end


"""
	angle_between_directions(a,b)

Return minimun angle between two directions.
"""
function angle_between_directions(a,b)
	value = LinearAlgebra.dot(a,b)/(LinearAlgebra.norm(a)*LinearAlgebra.norm(b))
	ag = LinearAlgebra.acos(clamp(value,-1.,1.))
	return min(ag, pi-ag)
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
# function height(direction:: Array{Float64,1}, V::Points)
# 	hmin = +Inf
# 	hmax = -Inf
#
# 	for i in 1:size(V,2)
# 		h = LinearAlgebra.dot(direction,V[:,i])
# 		if h > hmax
# 			hmax = h
# 		elseif h < hmin
# 			hmin = h
# 		end
# 	end
#
# 	return hmax-hmin
# end
# 
# """
# proiezioni
# """
# function projection(e,v)
# 	p = v - LinearAlgebra.dot(e,v)*e
# 	return p
# end
#
# function points_projection_on_plane(V::Points,plane::Hyperplane)
# 	N = plane.direction
# 	C = plane.centroid
# 	npoints = size(V,2)
# 	for i in 1:npoints
# 		V[:,i] = projection(N, V[:,i] - C) + C
# 	end
# 	return convert(Points,V)
# end
