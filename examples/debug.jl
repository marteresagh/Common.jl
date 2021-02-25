using Common
using Visualization

normal = rand(3)
centroid = rand(3)

vol = Volume([5,3,2.],[0,0,0.],[pi/3,0,0])
V_int = Common.box_intersects_plane(vol, normal, centroid)

V_p,FV_p = Common.DrawPlanes([Plane(normal,centroid)], Common.boundingbox(V))

V,EV,FV = getmodel(vol)
GL.VIEW([
	GL.GLPoints(convert(Lar.Points,V_int'))
	GL.GLGrid(V,EV)
	GL.GLGrid(V_p,FV_p)
])
