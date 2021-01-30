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
	function PCA(points::Lar.Points)

		npoints = size(points,2)
		@assert npoints>=3 "linefit: at least 2 points needed"
		centroid = Common.centroid(points)

		C = zeros(3,3)
		for i in 1:npoints
			diff = points[:,i] - centroid
			C += diff*diff'
		end

		#Lar.eigvals(C)
		eigvectors = Lar.eigvecs(C)
		R = eigvectors[:,[3,2,1]]
		if Lar.det(R)<0
			@show "negativo"
			R[:,3]=-R[:,3]
		end
		return centroid, R
	end

	center,R = PCA(points)
	V = Common.apply_matrix(Common.matrix4(Lar.inv(R)),points)
	x_range = extrema(V[1,:])
	y_range = extrema(V[2,:])
	z_range = extrema(V[3,:])
	extent = [x_range[2]-x_range[1],y_range[2]-y_range[1],z_range[2]-z_range[1]]

	return Volume(extent,center,Common.matrix2euler(R))

end
