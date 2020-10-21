#
# function IsNearToPlane(p::Array{Float64,1},plane::Hyperplane,par::Float64)::Bool
# 	return PointClouds.DistPointPlane(p,plane) <= par
# end

function Dist_Point2Plane(point::Array{Float64,1}, plane::Hyperplane)
	v = point - plane.centroid
	p_star = Lar.dot(plane.direction,v)*plane.direction
	return Lar.norm(p_star)
	#return Lar.abs(Lar.dot(point,plane.normal)-Lar.dot(plane.normal,plane.centroid))
end

"""
Orthogonal distance.
"""
function Dist_Point2Line(p::Array{Float64,1}, line::Hyperplane)
	v = p - line.centroid
	p_star = v - Lar.dot(line.direction,v)*line.direction
	return Lar.norm(p_star)
end

# """
# Check if point is close enough to model.
# """
# function isclosetoline(p::Array{Float64,1},line::Line,par::Hyperplane)
# 	return PointClouds.distpointtoline(p,line) < par
# end


function residual(point::Array{Float64,1},hyperplane::Hyperplane)
	if length(point) == 2
		return Dist_Point2Line(p, hyperplane)
	elseif length(point) == 3
		return Dist_Point2Plane(point, hyperplane)
	end
end
