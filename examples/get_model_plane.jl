using Visualization
using Common

aabb = AABB(2,0,2,0,2,0)
axis_y = rand(3)
thickness = 0.02
p2 = 2*rand(3)
p1 = 2*rand(3)
octree = Common.getmodel(aabb)

plane = Plane(p1,p2,axis_y)
p_model = Common.getmodel(p1,p2,axis_y,thickness,aabb)
p_model2 = Common.getmodel(plane, thickness, aabb)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,p1'),GL.COLORS[2])
	GL.GLPoints(convert(Lar.Points,p2'),GL.COLORS[2])
	GL.GLGrid(p_model[1],p_model[2])
	GL.GLGrid(p_model2[1],p_model2[2],GL.COLORS[2])
	GL.GLGrid(octree[1],octree[2])
	Visualization.helper_axis(Lar.inv(plane.matrix))...
	GL.GLFrame
]);

volume = Volume(2*rand(3),rand(3),2*pi*rand(3))
@show volume.scale
plane = Plane(volume)
p_model = Common.getmodel(volume)

GL.VIEW([
	GL.GLGrid(p_model[1],p_model[2])
	Visualization.helper_axis(Lar.inv(plane.matrix))...
	GL.GLFrame
]);

normal = rand(3)
normal/=Lar.norm(normal)
centroid = 2*rand(3)

plane = Plane(normal,centroid)
plane2 = Plane(normal[1],normal[2],normal[3], Lar.dot(normal, centroid) )

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,centroid'),GL.COLORS[2])
	GL.GLGrid(hcat([0,0,0.],normal),[[1,2]],GL.COLORS[1])
	Visualization.helper_axis(Lar.inv(plane.matrix))...
	Visualization.helper_axis(Lar.inv(plane2.matrix))...
	GL.GLFrame
]);
