"""
	box_intersects_plane(AABB::AABB, normal, centroid) -> Lar.Points

Return verteces of the intersection of a plane, described by `normal` and `centroid`, and an `AABB`.
"""
function box_intersects_plane(box::Union{AABB,Volume}, normal::Array{Float64,1}, centroid::Array{Float64,1})

	function pointint(i,j,lambda,allverteces)
		return allverteces[i]+lambda*(allverteces[j]-allverteces[i])
	end

	V,EV,FV = getmodel(box)

	allverteces = [c[:] for c in eachcol(V)]

	vertexpolygon = []
	for (i,j) in EV
		lambda = (Lar.dot(normal,centroid)-Lar.dot(normal,allverteces[i]))/Lar.dot(normal,allverteces[j]-allverteces[i])
		if lambda>=0 && lambda<=1
			push!(vertexpolygon,pointint(i,j,lambda,allverteces))
		end
	end

	V_int = hcat(vertexpolygon...)
	return Common.remove_double_verts(V_int, 2)[1]
end


"""
	AABBdetection(A::AABB,B::AABB) -> Bool

Compute collision detection of two AABB.
"""
function AABBdetection(A::AABB,B::AABB)::Bool
	twoD = A.z_min == A.z_max && B.z_min == B.z_max

	# 1. - axis x AleftB = A[1,max]<B[1,min]  ArightB = A[1,min]>B[1,max]
	# 2. - axis y AfrontB = A[2,max]<B[2,min]  AbehindB = A[2,min]>B[2,max]
	if twoD
		# 3. - axis z AbottomB = A[3,max]<B[3,min]  AtopB = A[3,min]>B[3,max]
		return !( A.x_max<=B.x_min || A.x_min>=B.x_max ||
				 A.y_max<=B.y_min || A.y_min>=B.y_max )

	end
	return  !( A.x_max<=B.x_min || A.x_min>=B.x_max ||
			 A.y_max<=B.y_min || A.y_min>=B.y_max ||
			  A.z_max<=B.z_min || A.z_min>=B.z_max )
end


"""
	inmodel(model::Lar.LAR)(p::Array{Float64,1}) -> Bool

Check if point `p` is in `model`.
"""
function inmodel(model::Lar.LAR)
	coordsystem = box_new_coords_system(model)
	newverts = coordsystem*model[1]
	A = Common.boundingbox(newverts)
	# a = [extrema(newverts[i,:]) for i in 1:3]
	# A = (hcat([a[1][1],a[2][1],a[3][1]]),hcat([a[1][2],a[2][2],a[3][2]]))

	function inmodel0(p::Array{Float64,1})
		newp = coordsystem*p
		# 1. - axis x AleftB = A[1,max]<B[1,min]  ArightB = A[1,min]>B[1,max]
		# 2. - axis y AfrontB = A[2,max]<B[2,min]  AbehindB = A[2,min]>B[2,max]
			# 3. - axis z AbottomB = A[3,max]<B[3,min]  AtopB = A[3,min]>B[3,max]
		return isinbox(A,newp)
		# return  (A.x_max>=newp[1] && A.x_min<=newp[1]) &&
		# 		(A.y_max>=newp[2] && A.y_min<=newp[2]) &&
		# 		(A.z_max>=newp[3] && A.z_min<=newp[3])
		end

	return inmodel0
end


"""
	separatingaxis(model::Lar.LAR,octree::AABB) -> Bool

The separating axis theorem (SAT) says that:
Two convex objects do not overlap if there exists a line (called axis) onto which the two objects' projections do not overlap.
"""
function separatingaxis(model::Lar.LAR,octree::AABB)::Bool
	# https://en.wikipedia.org/wiki/Hyperplane_separation_theorem
	# due box
	V,EV,FV = getmodel(octree)
	coordsystem = box_new_coords_system(model)

	#nuove coordinate
	newverts = coordsystem*model[1]
	newV = coordsystem*V

	#applico AABBdetection
	A = boundingbox(newverts)
	B = boundingbox(newV)

	return AABBdetection(A,B)
end


"""
	modelsdetection(model::Lar.LAR,AABB::AABB) -> 0, 1, 2

A `model` and an `AABB` intersection:
 - 0 -> model not intersect AABB
 - 1 -> model intersect but not contains AABB
 - 2 -> model contains AABB
"""

function modelsdetection(model::Lar.LAR,octree::AABB)::Int
	verts,edges,faces = model
	aabbmodel = Common.boundingbox(verts)
	if Common.AABBdetection(aabbmodel,octree)
		#ci sono 3 casi se i due bounding box si incontrano:
		# 1. octree è tutto interno  return 2
		# 2. octree esterno return 0
		# 3. octree intersecato ma non contenuto return 1
		Voctree,EVoctree,FVoctree = getmodel(octree)
		test = inmodel(model).([c[:] for c in eachcol(Voctree)])
		if test == ones(size(Voctree,2))
			return 2 # full model
		elseif !separatingaxis(model, octree)
			return 0
		else
			return 1
		end
	else
		return 0 # no intersection
	end
end


#--------------------

function planes_intersection(a::Plane,b::Plane)
	a_vec = [a.a,a.b,a.c]
	b_vec = [b.a,b.b,b.c]

	aXb_vec = Lar.cross(a_vec, b_vec)
	aXb_vec /= Lar.norm(aXb_vec)

	A = vcat(a_vec', b_vec', aXb_vec')
	d = reshape([a.d, b.d, 0.],3,1)
	p_inter = A\d
	return Lar.approxVal(8).(reshape(p_inter,3)), aXb_vec # point, direction of line intersection
end


function lines_intersection(line1::Hyperplane,line2::Hyperplane)
	l1 = [line1.centroid,line1.centroid+line1.direction]
	l2 = [line2.centroid,line2.centroid+line2.direction]
	return lines_intersection(l1,l2)
end


function lines_intersection(line1::Array{Array{Float64,1},1},line2::Array{Array{Float64,1},1})
	# line = [[x1,y1],[x2,y2]] start_point, end_point
	#http://www.pdas.com/lineint.html
	x1,y1,x2,y2 = vcat(line1...)
	x3,y3,x4,y4 = vcat(line2...)

	a1 = y2-y1;
	b1 = x1-x2;
	c1 = x2*y1 - x1*y2;  #{ a1*x + b1*y + c1 = 0 is line 1 }

	a2 = y4-y3;
	b2 = x3-x4;
	c2 = x4*y3 - x3*y4;  #{ a2*x + b2*y + c2 = 0 is line 2 }

	denom = a1*b2 - a2*b1;
	if denom == 0
		return nothing
	end

	x = (b1*c2 - b2*c1)/denom;
	y = (a2*c1 - a1*c2)/denom;
	return [x,y]
end



function models_intersection(V::Lar.Points,EV::Lar.Cells,FV::Lar.Cells)
	copEV = Lar.coboundary_0(EV)
	copFE = Lar.coboundary_1(V, FV, EV)
	W = permutedims(V)

	rV, rcopEV, rcopFE = Lar.Arrangement.spatial_arrangement_1(W, copEV, copFE, false)

	triangulated_faces = Lar.triangulate(rV, [rcopEV, rcopFE]);
	FVs = convert(Array{Lar.Cells}, triangulated_faces);

	indx = findall(x->x==0, length.(FVs))
	deleteat!(FVs, indx)

	V = permutedims(rV)
	return V, FVs
end
