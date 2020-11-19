using Visualization
using Common

aabb = AABB(2,-1,2,-1,2,-1)
axis_y = [0.,0.,1]
thickness = 0.02
p1 = [-1, 0, 0.]
p2 = [2., 3. , 2.]
octree = getmodel(aabb)

plane = Common.Plane(p1,p2,axis_y)
volume = Common.plane2model(p1,p2,axis_y,thickness,aabb)

plane = Common.Plane(0.7071067811865476, -0.7071067811865476, 0.0, -0.7071067811865477)
volume = Common.plane2model(plane,thickness,aabb)


GL.VIEW([
    GL.GLPoints(convert(Lar.Points,p1'),GL.COLORS[1])
	GL.GLPoints(convert(Lar.Points,p2'),GL.COLORS[2])
	GL.GLGrid(volume[1],volume[2])
	GL.GLGrid(octree[1],octree[2])
	Visualization.helper_axis(plane.matrix)...
	GL.GLFrame
]);
