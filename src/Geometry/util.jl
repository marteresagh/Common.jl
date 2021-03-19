"""
	angle_between_directions(a,b)

Return minimun angle between two directions.
"""
function angle_between_directions(a,b)
	value = Lar.dot(a,b)/(Lar.norm(a)*Lar.norm(b))
	ag = Lar.acos(clamp(value,-1.,1.))
	return min(ag, pi-ag)
end

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
	T = reshape(V,length(V),1)
	return apply_matrix(affineMatrix, T)
end

"""
	centroid(points::Lar.points)

Average of points.
"""
centroid(points::Union{Lar.Points,Array{Float64,1}}) = (sum(points,dims=2)/size(points,2))[:,1]

"""
	subtractaverage(points::Lar.Points)

Compute the average of the data points and traslate data.
Return vector of traslation and new data.
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

	u = Lar.cross(v,w)

	# @assert Lar.dot(w,v) ≈ 0. "Dot product = $(Lar.dot(w,v))"
	# @assert Lar.dot(w,u) ≈ 0. "Dot product = $(Lar.dot(w,u))"
	# @assert Lar.dot(u,v) ≈ 0. "Dot product = $(Lar.dot(u,v))"

	u /= Lar.norm(u)
	v /= Lar.norm(v)
	w /= Lar.norm(w)
	return hcat(u,v,w) # by column
end


function orthonormal_basis(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1})
	axis = (p2-p1)/Lar.norm(p2-p1)
	axis_y /= Lar.norm(axis_y)
	axis_z = Lar.cross(axis,axis_y)
	@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
	axis_z /= Lar.norm(axis_z)
	axis_x = Lar.cross(axis_y,axis_z)
	axis_x /= Lar.norm(axis_x)

	rot = hcat(axis_x, axis_y, axis_z)

	if Lar.det(rot)<0
		rot[:,3] = -rot[:,3]
	end
	return rot
end


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
proiezioni
"""
function projection(e,v)
	p = v - Lar.dot(e,v)*e
	return p
end

function points_projection_on_plane(V::Lar.Points,plane::Hyperplane)
	N = plane.direction
	C = plane.centroid
	npoints = size(V,2)
	for i in 1:npoints
		V[:,i] = projection(N, V[:,i] - C) + C
	end
	return convert(Lar.Points,V)
end
