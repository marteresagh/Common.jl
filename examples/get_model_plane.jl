using Visualization
using Common

aabb = AABB(2,0,2,0,2,0)
axis_y = rand(3)
thickness = 0.02
p2 = 2*rand(3)
p1 = 2*rand(3)
octree = Common.getmodel(aabb)


plane = Plane(p1,p2,axis_y)
volume = Common.getmodel(p1,p2,axis_y,thickness,aabb)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,p1'),GL.COLORS[2])
	GL.GLPoints(convert(Lar.Points,p2'),GL.COLORS[2])
	GL.GLGrid(volume[1],volume[2])
	GL.GLGrid(octree[1],octree[2])
	Visualization.helper_axis(Lar.inv(plane.matrix))...
	GL.GLFrame
]);
