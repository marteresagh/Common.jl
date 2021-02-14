"""
AABB
"""
function return_AABB(aabb)
	#aabb = ([x_min,y_min,z_min],[x_max,y_max,z_max])
	bb = [[a,b]  for (a,b) in zip(aabb[2],aabb[1])]
	return AABB(vcat(bb...)...)
end

"""
	boundingbox(points::Lar.Points) -> AABB

Axis aligned bounding box.
"""
function boundingbox(points::Lar.Points)::AABB
	a = [extrema(points[i,:]) for i in 1:size(points,1)]
	b = reverse.(a)
	return AABB(collect(Iterators.flatten(b))...)
end

"""
	update_boundingbox!(aabb::AABB,point)

Update bounding box.
"""
function update_boundingbox!(aabb::AABB,point::Array{Float64,1})
	x, y, z = point
	if x < aabb.x_min
		aabb.x_min = x
	end
	if y < aabb.y_min
		aabb.y_min = y
	end
	if z < aabb.z_min
		aabb.z_min = z
	end
	if x > aabb.x_max
		aabb.x_max = x
	end
	if y > aabb.y_max
		aabb.y_max = y
	end
	if z > aabb.z_max
		aabb.z_max = z
	end
end


"""
	isinbox(aabb::AABB,p::Array{Float64,1})

Check if point `p` is in a `aabb`.
"""
function isinbox(aabb::AABB,p::Array{Float64,1})
	return (  p[1]>=aabb.x_min && p[1]<=aabb.x_max &&
			  p[2]>=aabb.y_min && p[2]<=aabb.y_max &&
			   p[3]>=aabb.z_min && p[3]<=aabb.z_max )
end


"""
Oriented Bounding Box
"""
function oriented_boundingbox(points::Lar.Points)
	center_,R = Common.PCA(points)

	V = Common.apply_matrix(Common.matrix4(Lar.inv(R)),Common.apply_matrix(Lar.t(-center_...),points))
	aabb = Common.boundingbox(V)

	center_aabb = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	center = Common.apply_matrix(Common.matrix4(R),center_aabb) + center_
	extent = [aabb.x_max - aabb.x_min,aabb.y_max - aabb.y_min, aabb.z_max - aabb.z_min]

	return Volume(extent,vcat(center...),Common.matrix2euler(R))

end
