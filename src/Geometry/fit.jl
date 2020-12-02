"""
	Fit_Line(points::Lar.Points) -> direction, centroid

Returns best line fitting `points`.
Line description:
- direction
- centroid
"""
function Fit_Line(points::Lar.Points)

	npoints = size(points,2)
	@assert npoints>=2 "linefit: at least 2 points needed"
	centroid = Common.centroid(points)

	C = zeros(2,2)
	for i in 1:npoints
		diff = points[:,i] - centroid
		C += diff*diff'
	end

	#Lar.eigvals(C)
	eigvectors = Lar.eigvecs(C)
	direction = eigvectors[:,2]
    return direction,centroid
end

"""
	Fit_Line(points::Lar.Points) -> normal, centroid

Returns best plane fitting `points`.
Line description:
- normal
- centroid
"""
function Fit_Plane(points::Lar.Points)

	npoints = size(points,2)
	@assert npoints>=3 "PlaneFromPoints: at least 3 points needed"
	centroid,V = Common.subtractaverage(points)

	# Matrix
	xx = 0.; xy = 0.; xz = 0.;
	yy = 0.; yz = 0.; zz = 0.;

	for i in 1:npoints
		r = V[:,i]
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
	normal/=Lar.norm(normal)
	#plane = (a/Dmax,b/Dmax,c/Dmax,Lar.dot([a,b,c],centroid)/Dmax)
	return normal, centroid
end


"""
	LinearFit(points::Lar.Points) -> axis, centroid

Returns best model, plane or line, fitting `points`.
"""
function LinearFit(points::Lar.Points)
	if size(points,1) == 2
		return Fit_Line(points)
	elseif size(points,1) == 3
		return Fit_Plane(points)
	end
end
