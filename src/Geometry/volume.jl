"""
	volume2LARmodel(volume::Volume) -> Lar.LAR

Return volume model described by position, scale and rotation.
"""
function volume2LARmodel(volume::Volume)::Lar.LAR
	V,(VV,EV,FV,CV) = Lar.apply(Lar.t(-0.5,-0.5,-0.5),Lar.cuboid([1,1,1],true))
	scalematrix = Lar.s(volume.scale...)
	rot = Common.matrix4(Common.euler2matrix(volume.rotation...))
	trasl = Lar.t(volume.position...)
	affine = trasl*rot*scalematrix
	T = Common.apply_matrix(affine,V)
	return T,EV,FV
end


"""
	plane2model(plane::Plane, thickness::Float64, aabb::AABB) -> Lar.LAR

Return volume model of `plane` with `thickness`, limited in `aabb`.
"""
function plane2model(plane::Plane, thickness::Float64, aabb::AABB)::Lar.LAR
	plane2model(plane.matrix[1:3,1:3],plane.d,thickness,aabb)
end

function plane2model(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)::Lar.LAR
	verts,_ = getmodel(aabb)
	rotation = Common.matrix2euler(rot_mat)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	quota = rot_mat[:,3]*constant
	position = center_model+(quota-Lar.dot(rot_mat[:,3],center_model)*rot_mat[:,3])
	newverts = rot_mat'*verts
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])
	#extrema of newverts x e y
	scale = [x_range[2]-x_range[1],y_range[2]-y_range[1],thickness]
	volume = Volume(scale,position,rotation)
	model = Common.volume2LARmodel(volume)
	return model
end

"""
	 plane2model(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB) -> Lar.LAR

Return volume model of `plane` with `thickness` described by two points, `p1` and `p2`, and an up vector, `axis_y`, limited in `aabb` and between the two points.
"""
function plane2model(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB)::Lar.LAR
	axis = (p2-p1)/Lar.norm(p2-p1)
	axis_z = Lar.cross(axis,axis_y)
	@assert axis_z != [0.,0.,0.] "not a plane: $p1, $p2 collinear to $axis_y"
	axis_z /= Lar.norm(axis_z)
	axis_x = Lar.cross(axis_y,axis_z)
	axis_x /= Lar.norm(axis_x)

	center_model = Common.centroid(hcat(p1,p2))

	rot_mat = hcat(axis_x,axis_y,axis_z)
	V,_ = getmodel(aabb)

	dists_y = [Lar.dot(axis_y,V[:,i]) for i in 1:size(V,2)]
	min_y,max_y = extrema(dists_y)

	dists_x = [Lar.dot(axis_x,p1),Lar.dot(axis_x,p2)]
	min_x,max_x = extrema(dists_x)

	scale = [max_x-min_x, max_y-min_y, thickness]

	position = center_model-Lar.dot(rot_mat[:,2],center_model)*rot_mat[:,2]+Lar.dot(rot_mat[:,2],Common.centroid(V))*rot_mat[:,2]

	rotation = Common.matrix2euler(rot_mat)

	volume = Volume(scale,position,rotation)
	model = Common.volume2LARmodel(volume)
	return model
end
