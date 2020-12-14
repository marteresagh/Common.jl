"""
	Dist_Point2Plane(point::Array{Float64,1}, plane::Hyperplane)

Orthogonal distance `point` to `plane`.
"""
function Dist_Point2Plane(point::Array{Float64,1}, plane::Hyperplane)::Float64
	v = point - plane.centroid
	p_star = Lar.dot(plane.direction,v)*plane.direction
	return Lar.norm(p_star)
	#return Lar.abs(Lar.dot(point,plane.normal)-Lar.dot(plane.normal,plane.centroid))
end

"""
	Dist_Point2Line(point::Array{Float64,1}, line::Hyperplane)

Orthogonal distance `point` to `line`.
"""
function Dist_Point2Line(p::Array{Float64,1}, line::Hyperplane)::Float64
	v = p - line.centroid
	p_star = v - Lar.dot(line.direction,v)*line.direction
	return Lar.norm(p_star)
end

"""
	residual(hyperplane::Hyperplane)(point::Array{Float64,1})

Orthogonal distance `point` to `hyperplane`.
"""
function residual(hyperplane::Hyperplane)
	function residual0(point::Array{Float64,1})
		if length(point) == 2
			return Common.Dist_Point2Line(point, hyperplane)
		elseif length(point) == 3
			return Common.Dist_Point2Plane(point, hyperplane)
		end
	end
	return residual0
end

"""
	residual(hypersphere::Hypersphere)(point::Array{Float64,1})

Dreturn distance `point` to `hypersphere`.
"""
function residual(hypersphere::Hypersphere)
	function residual0(point::Array{Float64,1})
		rp = Lar.norm(point-hypersphere.center)
		return Lar.abs(rp-hypersphere.radius)
	end
	return residual0
end
