using Common
using Visualization
using FileManager

using Random
Random.seed!()
n_points = 10000
x = 12*rand(n_points)
y = 10*rand(n_points)
z = 2*rand(n_points)

points = vcat(x',y',z')
rot = Lar.r(0,2*pi*rand(),0)*Lar.r(0,0,2*pi*rand())*Lar.r(2*pi*rand(),0,0)
points = Common.apply_matrix(rot,points)

normal,centroid = Common.LinearFit(points)
plane = Plane(normal,centroid)
plane2 = Plane(points)
GL.VIEW([
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane.matrix,points)[1:2,:]'),GL.COLORS[2]),
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane2.matrix,points)[1:2,:]'),GL.COLORS[3]),
	GL.GLFrame2
])



normal,centroid = Common.LinearFit(points)
plane = Plane(normal,centroid)
points2D = Common.apply_matrix(plane.matrix,points)[1:2,:]
R = Common.basis_minimum_OBB_2D(points2D)
points2D_finali = Common.apply_matrix(Common.matrix4(Lar.inv(R))*plane.matrix,points)

GL.VIEW([
	#GL.GLPoints(convert(Lar.Points,points2D'),GL.COLORS[1]),
	GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[2]),
	GL.GLPoints(convert(Lar.Points,points2D_finali'),GL.COLORS[12]),
	GL.GLFrame
])
