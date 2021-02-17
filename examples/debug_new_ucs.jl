using Common
using Visualization
using FileManager

n_points = 10000
x = rand(1:10)*rand(n_points)
y = rand(1:10)*rand(n_points)
z = rand(1:10)*rand(n_points)

points = vcat(x',y',z')
rot = Lar.r(0,2*pi*rand(),0)*Lar.r(0,0,2*pi*rand())*Lar.r(2*pi*rand(),0,0)
points = Common.apply_matrix(rot,points)

cen = Common.centroid(points)


vol_old = Common.oriented_boundingbox(points)
obb_model_old = getmodel(vol_old)

vol = Common.ch_oriented_boundingbox(points)
obb_model = getmodel(vol)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,Common.apply_matrix(Lar.t(-cen...),points)')),
    GL.GLGrid(Common.apply_matrix(Lar.t(-cen...),obb_model[1]),obb_model[2],GL.COLORS[2],1.0),
	GL.GLGrid(Common.apply_matrix(Lar.t(-cen...),obb_model_old[1]),obb_model_old[2],GL.COLORS[3],1.0),
    GL.GLFrame,
])
