using Visualization
using Common



V = [0 1;1. 0; 0 0]
aabb = AABB(2,-1,2,-1,2,-1)
axis_y = [0.,0.,1]
thickness = 0.01
p1 = V[:,1]
p2 = V[:,2]

volume = plane2model(p1,p2,axis,thickness,aabb)
model = getmodel(aabb)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,V'),GL.COLORS[6])
	GL.GLGrid(volume[1],volume[2])
	GL.GLGrid(model[1],model[2])
	GL.GLFrame
]);
