"""
	distance_point2plane(centroid::Point, direction::Point)(point::Point)

Orthogonal distance `point` to `plane`.
"""
function distance_point2plane(centroid::Point, direction::Point)
	function distance_point2plane0(point::Point)::Float64
		v = point - centroid
		p_star = LinearAlgebra.dot(direction,v)*direction
		return LinearAlgebra.norm(p_star)
		#return LinearAlgebra.abs(LinearAlgebra.dot(point,plane.normal)-LinearAlgebra.dot(plane.normal,plane.centroid))
	end
	return distance_point2plane0
end

"""
	distance_point2line(centroid::Point, direction::Point)(point::Point)

Orthogonal distance `point` to `line`.
"""
function distance_point2line(centroid::Point, direction::Point)
	function distance_point2line0(point::Point)::Float64
		v = point - centroid
		p_star = v - LinearAlgebra.dot(direction,v)*direction
		return LinearAlgebra.norm(p_star)
	end
	return distance_point2line0
end

"""
	residual(hyperplane::Union{Plane,Line})(point::Point)

Orthogonal distance `point` to `hyperplane`.
"""
function residual(hyperplane::Union{Plane,Line})
	function residual0(point::Point)
		if length(point) == 2
			return distance_point2line(hyperplane.startPoint,hyperplane.direction)(point)
		elseif length(point) == 3
			return distance_point2plane(hyperplane.centroid,hyperplane.normal)(point)
		end
	end
	return residual0
end

"""
	residual(hypersphere::Hypersphere)(point::Point)

Dreturn distance `point` to `hypersphere`.
"""
function distance_point2sphere(center::Point,radius::Float64)
	function distance_point2sphere0(point::Point)::Float64
		rp = LinearAlgebra.norm(point-hypersphere.center)
		return LinearAlgebra.abs(rp-hypersphere.radius)
	end
	return distance_point2sphere0
end
