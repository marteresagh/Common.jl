# """
# DrawPlanes
# """
# function DrawPlanes(planes::Array{Hyperplane,1}; box_oriented=true)::LAR
# 	out = Array{Struct,1}()
# 	for obj in planes
# 		plane = Plane(obj.direction,obj.centroid)
# 		if box_oriented
# 			box = ch_oriented_boundingbox(obj.inliers.coordinates)
# 		else
# 			box = boundingbox(obj.inliers.coordinates)
# 		end
# 		cell = getmodel(plane,box)
# 		push!(out, Struct([cell]))
# 	end
# 	out = Struct( out )
# 	V, EV, FV = struct2lar(out)
# 	return V, EV, FV
# end
# function DrawPlanes(plane::Hyperplane; box_oriented=true)
# 	return DrawPlanes([plane],box_oriented=box_oriented)
# end
#
#
# function DrawPlanes(planes::Array{Hyperplane,1}, box::Union{AABB,Volume})::LAR
# 	out = Array{Struct,1}()
# 	for obj in planes
# 		plane = Plane(obj.direction,obj.centroid)
# 		cell = getmodel(plane,box)
# 		push!(out, Struct([cell])) # triangles cells
# 	end
# 	out = Struct( out )
# 	V, EV, FV = struct2lar(out)
# 	return V, EV, FV
# end
# function DrawPlanes(plane::Hyperplane, box::Union{AABB,Volume})
# 	return DrawPlanes([plane],box)
# end

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
Draw linear patches
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
Draw circle
"""
function DrawCircles()::LAR
	# out = Array{Struct,1}()
	# for i in 1:length(planes)
	# 	plane = planes[i]
	# 	box = boxes[i]
	# 	V,EV,FV = getmodel(plane, box)
	# 	push!(out, Struct([(V,EV,[union(FV...)])])) # unique cells
	# end
	# out = Struct( out )
	# V, EV, FV = struct2lar(out)
	# return V, EV, FV
end
