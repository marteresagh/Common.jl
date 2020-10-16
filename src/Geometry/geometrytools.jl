"""

"""
function DrawLine(line::Hyperplane, u=0.02)

	max_value = -Inf
	min_value = +Inf
	points = line.points
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
	for obj in lines
		V,EV = DrawLine(line, u)
		cell = (V,EV)
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,EV = Lar.struct2lar(out)
	return V,EV
end


"""
"""
#TODO da cambiare
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
		pp = obj.plane
		if !isnothing(AABB)
			V = intersectAABBplane(AABB,pp.normal,pp.centroid)
		else
			bb = Lar.boundingbox(obj.points.points).+([-u,-u,-u],[u,u,u])
			V = intersectAABBplane(bb,pp.normal,pp.centroid)
		end
		#triangulate vertex projected in plane XY
		FV = delaunay_triangulation(V[1:2,:])
		cell = (V,sort.(FV))
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,FV = Lar.struct2lar(out)
	return V, FV
end
