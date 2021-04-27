function PCA(points::Points)
	npoints = size(points,2)
	@assert npoints>=3 "PCA: at least 2 points needed"
	centroid = Common.centroid(points)

	C = zeros(3,3)
	for i in 1:npoints
		diff = points[:,i] - centroid
		C += diff*diff'
	end

	#LinearAlgebra.eigvals(C)
	eigvectors = LinearAlgebra.eigvecs(C)
	R = eigvectors[:,[3,2,1]]
	if LinearAlgebra.det(R)<0
		R[:,3]=-R[:,3]
	end
	R[:,1] /= LinearAlgebra.norm(R[:,1])
	R[:,2] /= LinearAlgebra.norm(R[:,2])
	R[:,3] /= LinearAlgebra.norm(R[:,3])
	return centroid, R
end

"""
	Fit_Line(points::Points) -> direction, centroid

Returns best line fitting 2D `points`.
Line description:
- direction
- centroid
"""
function Fit_Line(points::Points)

	npoints = size(points,2)
	@assert npoints>=2 "linefit: at least 2 points needed"
	centroid = Common.centroid(points)

	C = zeros(2,2)
	for i in 1:npoints
		diff = points[:,i] - centroid
		C += diff*diff'
	end

	#LinearAlgebra.eigvals(C)
	eigvectors = LinearAlgebra.eigvecs(C)
	direction = eigvectors[:,2]
    return direction,centroid
end

"""
	Fit_Plane(points::Points) -> normal, centroid

Returns best plane fitting 3D `points`.
Line description:
- normal
- centroid
"""
function Fit_Plane(points::Points)

	npoints = size(points,2)
	@assert npoints>=3 "PlaneFromPoints: at least 3 points needed"
	centroid = Common.centroid(points)

	# Matrix
	xx = 0.; xy = 0.; xz = 0.;
	yy = 0.; yz = 0.; zz = 0.;

	for i in 1:npoints
		r = points[:,i] - centroid
		xx+=r[1]^2
		xy+=r[1]*r[2]
		xz+=r[1]*r[3]
		yy+=r[2]^2
		yz+=r[2]*r[3]
		zz+=r[3]^2
	end

	Dx = yy*zz-yz^2
	Dy = xx*zz-xz^2
	Dz = xx*yy-xy^2
	Dmax = max(Dx,Dy,Dz)
	@assert Dmax>0 "PlaneFromPoints: not a plane"
	if Dmax==Dx
		a = Dx
		b = xz*yz - xy*zz
		c = xy*yz - xz*yy
	elseif Dmax==Dy
		a = xz*yz - xy*zz
		b = Dy
		c = xy*xz - yz*xx
	elseif Dmax==Dz
		a = xy*yz - xz*yy
		b = xy*xz - yz*xx
		c = Dz
	end
	normal = [a/Dmax,b/Dmax,c/Dmax]
	normal/=LinearAlgebra.norm(normal)
	#plane = (a/Dmax,b/Dmax,c/Dmax,LinearAlgebra.dot([a,b,c],centroid)/Dmax)
	return normal, centroid
end


"""
	LinearFit(points::Points) -> axis, centroid

Returns best model, plane or line, fitting `points`.
"""
function LinearFit(points::Points)
	if size(points,1) == 2
		return Fit_Line(points)
	elseif size(points,1) == 3
		return Fit_Plane(points)
	end
end


"""
	Fit_Circle(points::Points)

Returns best cirlce fitting 2D `points`.
Line description:
- normal
- centroid
"""
function Fit_Circle(points::Points)
	dim,npoints = size(points)
	@assert dim == 2 "Fit_Circle: dimension mismatch"
	C = centroid(points)
	M00 = 0.
	M01 = 0.
	M11 = 0.
	R = [0.,0.]

	for i in 1:npoints
		Y = points[:,i]-C
		Y0Y0 = Y[1]^2
		Y0Y1 = Y[1]*Y[2]
		Y1Y1 = Y[2]^2
		M00 += Y0Y0
		M01 += Y0Y1
		M11 += Y1Y1
		R += (Y0Y0+Y1Y1)*Y
	end

	R/=2
	det = M00*M11-M01^2
	@assert det != 0 "not a circle"
	center=[ C[1]+(M11*R[1]-M01*R[2])/det,
			 C[2]+(M00*R[2]-M01*R[1])/det]
	rsqr = 0
	for i in 1:npoints
		delta = points[:,i]-center
		rsqr += LinearAlgebra.dot(delta,delta)
	end
	rsqr /= npoints
	radius = sqrt(rsqr)

	return center,radius
end
