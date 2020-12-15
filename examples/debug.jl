using Common
using Visualization

points = rand(2,1000000)

FV = Common.delaunay_triangulation(points)

EV = Common.get_boundary_edges(points,FV)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	#GL.GLGrid(points,FV,GL.COLORS[2],1.0)
	GL.GLGrid(points,EV,GL.COLORS[12],1.0)
	#GL.GLFrame2
]);
