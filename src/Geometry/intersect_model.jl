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
inmodel(model)(p)

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
teorema degli assi separanti per conoscere l'intersezione di due box.
"""
function separatingaxis(model::Lar.LAR,octree::AABB)
	# le due box
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
A model and an AABB intersection:
 - 0 -> model not intersect AABB
 - 1 -> model intersect but not contains AABB
 - 2 -> model contains AABB
"""

function modelsdetection(model::Lar.LAR,octree::AABB)
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
