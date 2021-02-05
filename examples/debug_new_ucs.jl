using Common
using Visualization

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
        R[:,3]=-R[:,3]
    end
    R[:,1] /= Lar.norm(R[:,1])
    R[:,2] /= Lar.norm(R[:,2])
    R[:,3] /= Lar.norm(R[:,3])
    return centroid, R
end

function my_OrientedBB(points::Lar.Points)

	center_,R = PCA(points)

	V = Common.apply_matrix(Common.matrix4(Lar.inv(R)),Common.apply_matrix(Lar.t(-center_...),points))
	aabb = Common.boundingbox(V)

	center_aabb = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	center = Common.apply_matrix(Common.matrix4(R),center_aabb) + center_
	extent = [aabb.x_max - aabb.x_min,aabb.y_max - aabb.y_min, aabb.z_max - aabb.z_min]

	return Volume(extent,vcat(center...),Common.matrix2euler(R))

end

##########à esempio

M = Common.orthonormal_basis(1,1,1)

GL.VIEW([
	Visualization.helper_axis(Common.matrix4(M))...,
	GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(0,0,0))
])
