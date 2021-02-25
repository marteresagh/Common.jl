using Common
using Visualization

normal = rand(3)
centroid = rand(3)

vol = Volume([5,5,5.],[0,0,0.],[pi/3,0,pi/6])
V_int = Common.box_intersects_plane(vol, normal, centroid)
V,EV,FV = getmodel(vol)

V_p, EV_p, FV_p = Common.getmodel(Plane(normal,centroid), vol)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,V_int'))
	GL.GLGrid(V,EV)
	GL.GLGrid(V_p, FV_p)
])
