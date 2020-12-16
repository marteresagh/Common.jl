using Common
using Visualization

points = rand(2,100000)

FV = Common.delaunay_triangulation(points)

EV = Common.get_boundary_edges(points,FV)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	#GL.GLGrid(points,FV,GL.COLORS[2],1.0)
	GL.GLGrid(points,EV,GL.COLORS[12],1.0)
	#GL.GLFrame2
]);


################# DEBUG Delaunay
using AlphaStructures

points = rand(3,100000)

npoints = 10000
x = rand(npoints)
y = zeros(npoints)
z = rand(npoints)

wall_XZ = convert(Lar.Points, hcat(x,y,z)')

x = zeros(npoints)
y = rand(npoints)
z = rand(npoints)

wall_YZ = convert(Lar.Points, hcat(x,y,z)')

points = hcat(wall_XZ,wall_YZ)

using Detection
source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/MURI"
INPUT_PC = Detection.source2pc(source,1)

points = Common.apply_matrix(Lar.t(-Common.centroid(INPUT_PC.coordinates)...),INPUT_PC.coordinates)

DT = delaunayTriangulation(points)

FV = Common.delaunay_triangulation(points)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	#GL.GLGrid(points,FV,GL.COLORS[2],1.0)
	GL.GLGrid(points,FV,GL.COLORS[12],1.0)
	#GL.GLFrame2
]);
