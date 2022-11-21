"""
clusterizza in funzione della direzione una lista di linee
"""
function clustering_by_direction(lines::Vector{Line})
    clusters = []

    for line in lines
        found = false

        for cluster in clusters
            if Common.dot(line.direction,cluster[1].direction) > 0.98
                push!(cluster, line)
                found = true
                break
            end
        end

        if !found
            push!(clusters, [line])
        end
    end

    return clusters
end


"""
Restituisce il modello LAR delle linee
"""
function DrawLines(lines::Array{Line,1})::LAR
	out = Array{Struct,1}()
	for line in lines
		p_min = line.startPoint
		p_max = line.endPoint
		V = hcat(p_min,p_max)
		cell = (V,[[1,2]])
		push!(out, Struct([cell]))
	end
	out = Struct( out )
	V,EV = struct2lar(out)
	return V,EV
end
function DrawLines(line::Line)
	DrawLines([line])
end

function DrawPlanes(planes::Array{Plane,1}, box::Union{AABB,Volume})::LAR
	out = Array{Struct,1}()
	for plane in planes
		cell = getmodel(plane, box)
		push!(out, Struct([cell])) # triangles cells
	end
	out = Struct( out )
	V, EV, FV = struct2lar(out)
	return V, EV, FV
end
function DrawPlanes(plane::Plane, box::Union{AABB,Volume})
	DrawPlanes([plane],box)
end

"""
Restituisce il modello LAR delle patches
"""
function DrawPatches(planes::Array{Plane,1}, boxes::Union{Array{AABB,1},Array{Volume,1}})::LAR
	out = Array{Struct,1}()
	for i in 1:length(planes)
		plane = planes[i]
		box = boxes[i]
		V,EV,FV = getmodel(plane, box)
		push!(out, Struct([(V,EV,[union(FV...)])])) # unique cells
	end
	out = Struct( out )
	V, EV, FV = struct2lar(out)
	return V, EV, FV
end


"""
faces2triangles(V, FV)

Return collection of triangles of each convex cell in FV.
"""
function faces2triangles(V, FV)
  FVs = Vector{Vector{Int64}}[]
  for face in FV

    points_face = V[:, face]

    plane = Common.Plane(points_face)

    point_z_zero = Common.apply_matrix(plane.matrix, points_face)[1:2, :]

    triangle = Common.delaunay_triangulation(point_z_zero)
    push!(FVs, map(x -> face[x], triangle))
  end

  return FVs
end
