"""
	DrawLines(line::Hyperplane, u=0.02)

"""
function DrawLines(line::Hyperplane, u=0.02)
	DrawLines([line], u)
end

"""
	DrawLines(lines::Array{Hyperplane,1}, u=0.2)

"""
function DrawLines(lines::Array{Hyperplane,1}, u=0.2)
	out = Array{Lar.Struct,1}()
	for line in lines
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
		cell = (V,[[1,2]])
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,EV = Lar.struct2lar(out)
	return V,EV
end
#
# """
# 	DrawPlanes(plane::Hyperplane, AABB::Union{AABB,Nothing})
#
# """
# function  DrawPlanes(plane::Hyperplane, AABB::Union{AABB,Nothing})
# 	DrawPlanes([plane], AABB)
# end
#
# """
# 	DrawPlanes(planes::Array{Hyperplane,1}, AABB::Union{AABB,Nothing})
#
# """
# function DrawPlanes(planes::Array{Hyperplane,1}, AABB::Union{AABB,Nothing})
# 	out = Array{Lar.Struct,1}()
# 	bb = deepcopy(AABB)
# 	for obj in planes
# 		plane = Plane(obj.direction,obj.centroid)
# 		points = obj.inliers.coordinates
# 		if isnothing(AABB)
# 			bb = Common.boundingbox(points)
# 		end
# 		points_flat = Common.apply_matrix(plane.matrix,points)
# 		extrema_x = extrema(points_flat[1,:])
# 		extrema_y = extrema(points_flat[2,:])
# 		extrema_z = extrema(points_flat[3,:])
# 		Vol = Volume([extrema_x[2]-extrema_x[1],extrema_y[2]-extrema_y[1],extrema_z[2]-extrema_z[1]],obj.centroid,Common.matrix2euler(Lar.inv(plane.matrix)))
# 		#triangulate vertex projected in plane XY
# 		V,EV,FV = getmodel(Vol)
# 		# FV = Common.delaunay_triangulation(V[1:2,:])
# 		cell = (V,sort.(FV))
# 		push!(out, Lar.Struct([cell]))
# 	end
# 	out = Lar.Struct( out )
# 	V,FV = Lar.struct2lar(out)
# 	return V,FV
# end
#
# #
# #TODO da cambiare togliere triangolazione
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
