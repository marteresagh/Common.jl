using Visualization
using Common

V = [0 4;2. 0; 2 0]
aabb = AABB(2,-1,2,-1,2,-1)
axis_y = [0.,0.,1]
thickness = 0.02
p1 = V[:,1]
p2 = V[:,2]

volume = Common.plane2model(p1,p2,axis_y,thickness,aabb)
model = getmodel(aabb)

plane = Common.Plane(p1,p2,axis_y)

volume2 = Common.plane2model(plane,thickness,aabb)
GL.VIEW([
    GL.GLPoints(convert(Lar.Points,V'),GL.COLORS[6])
	GL.GLGrid(volume[1],volume[2])
	GL.GLGrid(volume2[1],volume2[2])
	GL.GLGrid(model[1],model[2])
	GL.GLFrame
]);
