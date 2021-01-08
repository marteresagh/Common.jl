"""

"""
function DrawLine(line::Hyperplane, u=0.02)
	max_value = -Inf
	min_value = +Inf
	points = line.inliers
	for i in 1:points.n_points
		p = points.coordinates[:,i] - line.centroid
		value = Lar.dot(line.direction,p)
		if value > max_value
			max_value = value
		end
		if value < min_value
			min_value = value
		end
	end
	p_min = line.centroid + (min_value - u)*line.direction
	p_max = line.centroid + (max_value + u)*line.direction
	V = hcat(p_min,p_max)
	EV = [[1,2]]
    return V, EV
end

"""

"""
function DrawLines(lines::Array{Hyperplane,1}, u=0.2)
	out = Array{Lar.Struct,1}()
	for line in lines
		V,EV = DrawLine(line, u)
		cell = (V,EV)
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,EV = Lar.struct2lar(out)
	return V,EV
end

#--------------------TODO da modificare
"""
"""
#TODO da cambiare e farla tipo la line senza triangolazione
function DrawPlane(plane::Hyperplane, AABB::AABB)
	V = intersectAABBplane(AABB,plane.direction,plane.centroid)
	#triangulate vertex projected in plane XY
	FV = delaunay_triangulation(V[1:2,:])
	return V, sort.(FV)
end

"""
"""
function DrawPlanes(planes::Array{Hyperplane,1}, AABB::Union{AABB,Nothing}, u=0.2)
	out = Array{Lar.Struct,1}()
	for obj in planes
		if !isnothing(AABB)
			V = intersectAABBplane(AABB,obj.direction,obj.centroid)
		else
			bb = Lar.boundingbox(obj.inliers.coordinates).+([-u,-u,-u],[u,u,u])
			bb = Common.return_AABB(bb)
			V = Common.intersectAABBplane(bb,obj.direction,obj.centroid)
		end
		#triangulate vertex projected in plane XY
		FV = Common.delaunay_triangulation(V[1:2,:])
		cell = (V,sort.(FV))
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,FV = Lar.struct2lar(out)
	return V, FV
end
#--------------------


function lines_intersection(l1::Hyperplane,l2::Hyperplane)

end
