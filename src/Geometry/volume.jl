"""
	volumemodelfromjson(path::String)

Return LAR model of Potree volume tools.
"""
function volume2LARmodel(volume::Volume)
	V,(VV,EV,FV,CV) = Lar.apply(Lar.t(-0.5,-0.5,-0.5),Lar.cuboid([1,1,1],true))
	scalematrix = Lar.s(volume.scale...)
	rot = Common.matrix4(Common.euler2matrix(volume.rotation...))
	trasl = Lar.t(volume.position...)
	affine = trasl*rot*scalematrix
	T = Common.apply_matrix(affine,V)
	return T,EV,FV
end


"""
get model of plane with thickness
"""
function plane2model(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)
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

function plane2model(plane::Plane, thickness::Float64, aabb::AABB)
	plane2model(plane.matrix[1:3,1:3],plane.d,thickness,aabb)
end
