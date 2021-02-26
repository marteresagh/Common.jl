"""
	DrawLines(lines::Array{Hyperplane,1})

"""
function DrawLines(lines::Array{Hyperplane,1})
	out = Array{Lar.Struct,1}()
	for line in lines
		max_value = -Inf
		min_value = +Inf
		points = line.inliers
		for i in 1:points.n_points
			p = points.coordinates[:,i] - line.centroid
			value = Lar.dot(line.direction,p)
			if value > max_value
				max_value = value
			end
			if value < min_value
				min_value = value
			end
		end
		p_min = line.centroid + (min_value)*line.direction
		p_max = line.centroid + (max_value)*line.direction
		V = hcat(p_min,p_max)
		cell = (V,[[1,2]])
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,EV = Lar.struct2lar(out)
	return V,EV
end
function DrawLines(line::Hyperplane)
	DrawLines([line])
end


"""
DrawPlanes
"""
function DrawPlanes(planes::Array{Hyperplane,1}; box_oriented=true)
	out = Array{Lar.Struct,1}()
	for obj in planes
		plane = Plane(obj.direction,obj.centroid)
		if box_oriented
			box = Common.ch_oriented_boundingbox(obj.inliers.coordinates)
		else
			box = Common.boundingbox(obj.inliers.coordinates)
		end
		cell = getmodel(plane,box)
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V, EV, FV = Lar.struct2lar(out)
	return V, EV, FV
end
function DrawPlanes(plane::Hyperplane; box_oriented=true)
	return DrawPlanes([plane],box_oriented=box_oriented)
end


function DrawPlanes(planes::Array{Hyperplane,1}, box::Union{AABB,Volume})
	out = Array{Lar.Struct,1}()
	for obj in planes
		plane = Plane(obj.direction,obj.centroid)
		cell = getmodel(plane,box)
		push!(out, Lar.Struct([cell])) # triangles cells
	end
	out = Lar.Struct( out )
	V, EV, FV = Lar.struct2lar(out)
	return V, EV, FV
end
function DrawPlanes(plane::Hyperplane, box::Union{AABB,Volume})
	return DrawPlanes([plane],box)
end


function DrawPlanes(planes::Array{Plane,1}, box::Union{AABB,Volume})
	out = Array{Lar.Struct,1}()
	for plane in planes
		cell = getmodel(plane, box)
		push!(out, Lar.Struct([cell])) # triangles cells
	end
	out = Lar.Struct( out )
	V, EV, FV = Lar.struct2lar(out)
	return V, EV, FV
end
function DrawPlanes(plane::Plane, box::Union{AABB,Volume})
	DrawPlanes([plane],box)
end

"""
Draw linear patches
"""
function DrawPatches(planes::Array{Plane,1}, boxes::Array{Union{AABB,Volume},1})
	out = Array{Lar.Struct,1}()
	for i in 1:length(planes)
		plane = planes[i]
		box = boxes[i]
		V,EV,FV = getmodel(plane, box)
		push!(out, Lar.Struct([(V,EV, union(FV...))])) # unique cells
	end
	out = Lar.Struct( out )
	V, EV, FV = Lar.struct2lar(out)
	return V, EV, FV
end
