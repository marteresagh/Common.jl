"""
	getmodel(aabb::AABB) -> model::LAR

Return LAR model of the aligned axis box defined by `aabb`.
"""
function getmodel(aabb::AABB)::LAR
	V = [	aabb.x_min  aabb.x_min  aabb.x_min  aabb.x_min  aabb.x_max  aabb.x_max  aabb.x_max  aabb.x_max;
		 	aabb.y_min  aabb.y_min  aabb.y_max  aabb.y_max  aabb.y_min  aabb.y_min  aabb.y_max  aabb.y_max;
		 	aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max  aabb.z_min  aabb.z_max ]
	EV = [[1, 2],  [3, 4], [5, 6],  [7, 8],  [1, 3],  [2, 4],  [5, 7],  [6, 8],  [1, 5],  [2, 6],  [3, 7],  [4, 8]]
	FV = [[1, 2, 3, 4],  [5, 6, 7, 8],  [1, 2, 5, 6],  [3, 4, 7, 8],  [1, 3, 5, 7],  [2, 4, 6, 8]]
	return V,EV,FV
end


"""
	getmodel(volume::Volume) -> model::LAR

Return volume model described by position, scale and rotation.
"""
function getmodel(volume::Volume)::LAR
	cube_verts = [ 0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0;
 		  0.0  0.0  1.0  1.0  0.0  0.0  1.0  1.0;
 		  0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0]
	V = apply_matrix(Common.t(-0.5,-0.5,-0.5),cube_verts)
	EV = [[1, 2], [3, 4], [5, 6], [7, 8],[1, 3], [2, 4], [5, 7], [6, 8], [1, 5], [2, 6], [3, 7], [4, 8]]
	FV = [[1, 2, 3, 4], [5, 6, 7, 8], [1, 2, 5, 6], [3, 4, 7, 8], [1, 3, 5, 7], [2, 4, 6, 8]]

	scalematrix = Common.s(volume.scale...)
	rot = matrix4(euler2matrix(volume.rotation...))
	trasl = Common.t(volume.position...)
	affine = trasl*rot*scalematrix
	T = apply_matrix(affine,V)
	return T,EV,FV
end

"""
	getmodel(plane::Plane, thickness::Float64, aabb::AABB) -> model::LAR

Return volume model of `plane` with `thickness`, limited in `aabb`.
"""
function getmodel(plane::Plane, thickness::Float64, aabb::AABB)::LAR
	getmodel(LinearAlgebra.inv(plane.matrix[1:3,1:3]),plane.d,thickness,aabb)
end

function getmodel(basis::Matrix, constant::Float64, thickness::Float64, aabb::AABB; new_origin = [0.0,0.0,0.0]::Array{Float64,1})::LAR
	verts,_ = getmodel(aabb)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	quota = basis[:,3]*constant

	position = center_model+(quota-LinearAlgebra.dot(basis[:,3],center_model-new_origin)*basis[:,3])
	newverts = basis'*verts
	#extrema of newverts x e y
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])

	scale = [x_range[2]-x_range[1]+1.e-2,y_range[2]-y_range[1]+1.e-2,thickness]
	volume = Volume(scale,position,matrix2euler(basis))
	return getmodel(volume)
end

"""
	 getmodel(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB) -> model::LAR

Return volume model of `plane` with `thickness` described by two points, `p1` and `p2`, and an up vector, `axis_y`, limited in `aabb` and between the two points.
"""
function getmodel(p1::Array{Float64,1}, p2::Array{Float64,1}, axis_y::Array{Float64,1}, thickness::Float64, aabb::AABB)::LAR
	rot_mat = orthonormal_basis(p1, p2, axis_y)
	axis_x = rot_mat[:,1]
	axis_y = rot_mat[:,2]
	axis_z = rot_mat[:,3]

	center_model = centroid(hcat(p1,p2))
	V,_ = getmodel(aabb)

	dists_y = [LinearAlgebra.dot(axis_y,V[:,i]) for i in 1:size(V,2)]
	min_y,max_y = extrema(dists_y)

	dists_x = [LinearAlgebra.dot(axis_x,p1),LinearAlgebra.dot(axis_x,p2)]
	min_x,max_x = extrema(dists_x)

	scale = [max_x-min_x, max_y-min_y, thickness]

	position = center_model-LinearAlgebra.dot(rot_mat[:,2],center_model)*rot_mat[:,2]+LinearAlgebra.dot(rot_mat[:,2],centroid(V))*rot_mat[:,2]

	volume = Volume(scale,position,matrix2euler(rot_mat))
	return getmodel(volume)
end

"""
	 getmodel(plane::Plane,box::Union{AABB,Volume} ) -> model::LAR

Return LAR model of `plane` intersecting `box`.
"""
function getmodel(plane::Plane,box::Union{AABB,Volume} )::LAR
	V = box_intersects_plane(box, plane.normal, plane.centroid)
	points2D = apply_matrix(plane.matrix,V)[1:2,:]
	FV = delaunay_triangulation(points2D)
	EV = get_boundary_edges(points2D,FV)
	return V,EV,FV
end
