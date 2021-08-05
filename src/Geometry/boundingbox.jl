"""
AABB
"""
function return_AABB(aabb)::AABB
	#aabb = ([x_min,y_min,z_min],[x_max,y_max,z_max])
	bb = [[a,b]  for (a,b) in zip(aabb[2],aabb[1])]
	return AABB(vcat(bb...)...)
end

"""
	boundingbox(points::Points) -> AABB

Axis aligned bounding box.
"""
function boundingbox(points::Points)::AABB
	a = [extrema(points[i,:]) for i in 1:size(points,1)]
	b = reverse.(a)
	return AABB(collect(Iterators.flatten(b))...)
end

"""
	update_boundingbox!(aabb::AABB,point)

Update bounding box.
"""
function update_boundingbox!(aabb::AABB,point::Point)
	x, y, z = point
	aabb.x_min = min(aabb.x_min, x)
	aabb.y_min = min(aabb.y_min, y)
	aabb.z_min = min(aabb.z_min, z)
	aabb.x_max = max(aabb.x_max, x)
	aabb.y_max = max(aabb.y_max, y)
	aabb.z_max = max(aabb.z_max, z)
end

function update_boundingbox!(aabb::AABB, bbcc::AABB)
	p_min = [bbcc.x_min,bbcc.y_min,bbcc.z_min]
	p_max = [bbcc.x_max, bbcc.y_max, bbcc.z_max]
	update_boundingbox!(aabb,p_min)
	update_boundingbox!(aabb,p_max)
end


"""
	oriented_boundingbox(points::Points)
"""
function oriented_boundingbox(points::Points)::Volume
	center_,R = PCA(points)

	V = apply_matrix(matrix4(LinearAlgebra.inv(R)),apply_matrix(Common.t(-center_...),points))
	aabb = boundingbox(V)

	center_aabb = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	center = apply_matrix(matrix4(R),center_aabb) + center_
	extent = [aabb.x_max - aabb.x_min,aabb.y_max - aabb.y_min, aabb.z_max - aabb.z_min]

	return Volume(extent,vcat(center...),matrix2euler(R))

end

"""
	ch_oriented_boundingbox(points::Points)
"""
function ch_oriented_boundingbox(points::Points)::Volume
	R = nothing
	volume_value_min = Inf
	convex_hull = QHull.chull(permutedims(points))
	for face in convex_hull.simplices # TODO non per ogni faccia triangolare ma per ogni faccia planare
		plane = Plane(points[:,face])
		rotate_points = apply_matrix(plane.matrix, points)
		aabb = boundingbox(rotate_points)
		volume_value = (aabb.x_max-aabb.x_min)*(aabb.y_max-aabb.y_min)*(aabb.z_max-aabb.z_min)
		if volume_value_min > volume_value
			volume_value_min = volume_value
			R = plane.basis
		end
	end

	center_ = centroid(points)

	V = apply_matrix(matrix4(LinearAlgebra.inv(R)),apply_matrix(Common.t(-center_...),points))
	aabb = boundingbox(V)

	center_aabb = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	center = apply_matrix(matrix4(R),center_aabb) + center_
	extent = [aabb.x_max - aabb.x_min,aabb.y_max - aabb.y_min, aabb.z_max - aabb.z_min]

	return Volume(extent,vcat(center...),matrix2euler(R))
end


"""
	basis_minimum_OBB_2D(points::Points)
"""
function basis_minimum_OBB_2D(points::Points)
	R = nothing
	area_value_min = Inf
	convex_hull = QHull.chull(permutedims(points))
	for edge in convex_hull.simplices
		x_axis,centroid = LinearFit(points[:,edge])
		y_axis = LinearAlgebra.cross([x_axis...,0.],[0,0,1.])
		y_axis/=LinearAlgebra.norm(y_axis)
		matrix = vcat(x_axis',y_axis[1:2]')
		if LinearAlgebra.det(matrix)<0
			matrix = matrix[[2,1],:]
		end
		matrix = vcat(hcat(matrix,[0,0]),[0.,0.,1.]')
		rotate_points = apply_matrix(matrix, points)
		aabb = boundingbox(rotate_points)
		area_value = (aabb.x_max-aabb.x_min)*(aabb.y_max-aabb.y_min)
		if area_value_min > area_value
			area_value_min = area_value
			R = LinearAlgebra.inv(matrix)
		end
	end
	return R
end
