using Visualization
using Common

aabb = AABB(2,-1,2,-1,2,-1)
axis_y = [0.,0.,1]
thickness = 0.02
p1 = [-1, 0, 0.]
p2 = [2., 3. , 2.]
octree = getmodel(aabb)

plane = Plane(p1,p2,axis_y)
volume = Common.getmodel(p1,p2,axis_y,thickness,aabb)

vol = Volume([3.,3.,0.],[1.,2.,1.],[pi/3,pi,pi/4.])
plane = Plane(vol)
volume = Common.getmodel(vol)

plane2 = Plane(plane.a,plane.b,plane.c,plane.d)
volume = Common.getmodel(p1,p2,axis_y,thickness,aabb)

GL.VIEW([
	# GL.GLPoints(convert(Lar.Points,p1'),GL.COLORS[2])
	# GL.GLPoints(convert(Lar.Points,p2'),GL.COLORS[2])
	GL.GLGrid(volume[1],volume[2])
#	GL.GLGrid(Common.apply_matrix(plane2.matrix,volume[1]),volume[2], GL.COLORS[2])
	#GL.GLGrid(octree[1],octree[2])
#	Visualization.helper_axis(Lar.inv(plane2.matrix))...
	GL.GLFrame
]);
