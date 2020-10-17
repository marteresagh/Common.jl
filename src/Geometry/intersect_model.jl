"""
Return verteces of the intersection of a `plane` and an `AABB`.
"""
function intersectAABBplane(AABB::AABB, normal, centroid)

    function pointint(i,j,lambda,allverteces)
        return allverteces[i]+lambda*(allverteces[j]-allverteces[i])
    end

	coordAABB = [AABB.x_min AABB.x_max; AABB.y_min AABB.y_max; AABB.z_min AABB.z_max ]

    allverteces = []
    for x in coordAABB[1,:]
        for y in coordAABB[2,:]
            for z in coordAABB[3,:]
                push!(allverteces,[x,y,z])
            end
        end
    end

    vertexpolygon = []
    for (i,j) in Lar.larGridSkeleton([1,1,1])(1)
        lambda = (Lar.dot(normal,centroid)-Lar.dot(normal,allverteces[i]))/Lar.dot(normal,allverteces[j]-allverteces[i])
        if lambda>=0 && lambda<=1
            push!(vertexpolygon,pointint(i,j,lambda,allverteces))
        end
    end
    return hcat(vertexpolygon...)
end


"""
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
check if point p is in model.
"""
function inmodel(model)
	verts,edges,faces = model
	axis_x = (verts[:,5]-verts[:,1])/Lar.norm(verts[:,5]-verts[:,1])
	axis_y = (verts[:,2]-verts[:,1])/Lar.norm(verts[:,2]-verts[:,1])
	axis_z = (verts[:,3]-verts[:,1])/Lar.norm(verts[:,3]-verts[:,1])
	coordsystem = [axis_x';axis_y';axis_z']
	newverts = coordsystem*verts
	a = [extrema(newverts[i,:]) for i in 1:3]
	A = (hcat([a[1][1],a[2][1],a[3][1]]),hcat([a[1][2],a[2][2],a[3][2]]))

	function inmodel0(p)
		newp = coordsystem*p
		# 1. - axis x AleftB = A[1,max]<B[1,min]  ArightB = A[1,min]>B[1,max]
		# 2. - axis y AfrontB = A[2,max]<B[2,min]  AbehindB = A[2,min]>B[2,max]
			# 3. - axis z AbottomB = A[3,max]<B[3,min]  AtopB = A[3,min]>B[3,max]
		return (A[2][1]>=newp[1] && A[1][1]<=newp[1]) &&
					 (A[2][2]>=newp[2] && A[1][2]<=newp[2]) &&
					  (A[2][3]>=newp[3] && A[1][3]<=newp[3])
	end
	return inmodel0
end

"""
A model and an AABB intersection:
 - 0 -> model not intersect AABB
 - 1 -> model intersect but not contains AABB
 - 2 -> model contains AABB
"""

function modelsdetection(model,octree::AABB)
	verts,edges,faces = model
	aabbmodel = Common.boundingbox(verts)
	if Common.AABBdetection(aabbmodel,octree)
		#ci sono 3 casi se i due bounding box si incontrano:
		# 1. octree è tutto interno  return 2
		# 2. octree esterno return 0
		# 3. octree intersecato ma non contenuto return 1
		Voctree,EVoctree,FVoctree = getmodel(octree)
		test = inmodel(model).([Voctree[:,i] for i in 1:size(Voctree,2)])
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

#TODO da finire
function separatingaxis(model,octree::AABB)
	V,EV,FV = getmodel(octree)
	verts,edges,faces = model
	axis_x = (verts[:,5]-verts[:,1])/Lar.norm(verts[:,5]-verts[:,1])
	axis_y = (verts[:,2]-verts[:,1])/Lar.norm(verts[:,2]-verts[:,1])
	axis_z = (verts[:,3]-verts[:,1])/Lar.norm(verts[:,3]-verts[:,1])
	coordsystem = [axis_x';axis_y';axis_z']
	newverts = coordsystem*verts
	newV = coordsystem*V
	newaabb = [extrema(newverts[i,:]) for i in 1:3]
	newAABB = [extrema(newV[i,:]) for i in 1:3]

	aabb =[[a,b]  for (a,b) in zip(newaabb[2],newaabb[1])]
	A = AABB(vcat(aabb...)...)

	aabb2 =[[a,b]  for (a,b) in zip(newAABB[2],newAABB[1])]
	B = AABB(vcat(aabb2...)...)
	#aabb = (hcat([newaabb[1][1],newaabb[2][1],newaabb[3][1]]),hcat([newaabb[1][2],newaabb[2][2],newaabb[3][2]]))
	#AABB = (hcat([newAABB[1][1],newAABB[2][1],newAABB[3][1]]),hcat([newAABB[1][2],newAABB[2][2],newAABB[3][2]]))
	return AABBdetection(aabb,AABB)
end
