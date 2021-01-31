"""
	getmodel(aabb::AABB) -> model::Lar.LAR

Return LAR model of the aligned axis box defined by `aabb`.
"""
function getmodel(aabb::AABB)::Lar.LAR
	V = [	aabb.x_min  aabb.x_min  aabb.x_min  aabb.x_min  aabb.x_max  aabb.x_max  aabb.x_max  aabb.x_max;
		 	aabb.y_min  aabb.y_min  aabb.y_max  aabb.y_max  aabb.y_min  aabb.y_min  aabb.y_max  aabb.y_max;
		 	aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max ]
	EV = [[1, 2],  [3, 4], [5, 6],  [7, 8],  [1, 3],  [2, 4],  [5, 7],  [6, 8],  [1, 5],  [2, 6],  [3, 7],  [4, 8]]
	FV = [[1, 2, 3, 4],  [5, 6, 7, 8],  [1, 2, 5, 6],  [3, 4, 7, 8],  [1, 3, 5, 7],  [2, 4, 6, 8]]
	return V,EV,FV
end


"""
	getmodel(volume::Volume) -> model::Lar.LAR

Return volume model described by position, scale and rotation.
"""
function getmodel(volume::Volume)::Lar.LAR
	V,(VV,EV,FV,CV) = Lar.apply(Lar.t(-0.5,-0.5,-0.5),Lar.cuboid([1,1,1],true))
	scalematrix = Lar.s(volume.scale...)
	rot = Common.matrix4(Common.euler2matrix(volume.rotation...))
	trasl = Lar.t(volume.position...)
	affine = trasl*rot*scalematrix
	T = Common.apply_matrix(affine,V)
	return T,EV,FV
end

"""
	getmodel(plane::Plane, thickness::Float64, aabb::AABB) -> model::Lar.LAR

Return volume model of `plane` with `thickness`, limited in `aabb`.
"""
function getmodel(plane::Plane, thickness::Float64, aabb::AABB)::Lar.LAR
	getmodel(plane.matrix[1:3,1:3],plane.d,thickness,aabb)
end

function getmodel(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)::Lar.LAR
	verts,_ = getmodel(aabb)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	quota = rot_mat[:,3]*constant

	position = center_model+(quota-Lar.dot(rot_mat[:,3],center_model)*rot_mat[:,3])
	newverts = rot_mat'*verts
	#extrema of newverts x e y
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])

	scale = [x_range[2]-x_range[1]+1.e-2,y_range[2]-y_range[1]+1.e-2,thickness]
	volume = Volume(scale,position,rot_mat)
	model = Common.getmodel(volume)
	return model
end

"""
	 getmodel(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB) -> model::Lar.LAR

Return volume model of `plane` with `thickness` described by two points, `p1` and `p2`, and an up vector, `axis_y`, limited in `aabb` and between the two points.
"""
function getmodel(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB)::Lar.LAR
	axis = (p2-p1)/Lar.norm(p2-p1)
	axis_z = Lar.cross(axis,axis_y)
	@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
	axis_z /= Lar.norm(axis_z)
	axis_x = Lar.cross(axis_y,axis_z)
	axis_x /= Lar.norm(axis_x)

	center_model = Common.centroid(hcat(p1,p2))

	rot_mat = hcat(axis_x,axis_y,axis_z)

	@assert isapprox(Lar.det(rot_mat),1) "Basis orientation not right-handed"

	V,_ = getmodel(aabb)

	dists_y = [Lar.dot(axis_y,V[:,i]) for i in 1:size(V,2)]
	min_y,max_y = extrema(dists_y)

	dists_x = [Lar.dot(axis_x,p1),Lar.dot(axis_x,p2)]
	min_x,max_x = extrema(dists_x)

	scale = [max_x-min_x, max_y-min_y, thickness]

	position = center_model-Lar.dot(rot_mat[:,2],center_model)*rot_mat[:,2]+Lar.dot(rot_mat[:,2],Common.centroid(V))*rot_mat[:,2]

	volume = Volume(scale,position,rot_mat)
	model = Common.getmodel(volume)
	return model
end
