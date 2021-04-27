using Common
using Visualization
using BenchmarkTools

n_points = 100000
x = rand(1:10)*rand(n_points)
y = rand(1:10)*rand(n_points)
z = rand(n_points)

points = vcat(x',y',z')
rot = Common.r(0,2*pi*rand(),0)*Common.r(0,0,2*pi*rand())*Common.r(2*pi*rand(),0,0)
points = Common.apply_matrix(rot,points)

cen = Common.centroid(points)

vol_old = Common.oriented_boundingbox(points)
obb_model_old = Common.getmodel(vol_old)

vol = Common.ch_oriented_boundingbox(points)
obb_model = Common.getmodel(vol)

Visualization.VIEW([
    Visualization.points(Common.apply_matrix(Common.t(-cen...),points)),
    Visualization.GLGrid(Common.apply_matrix(Common.t(-cen...),obb_model[1]),obb_model[2],Visualization.COLORS[2],1.0),
	Visualization.GLGrid(Common.apply_matrix(Common.t(-cen...),obb_model_old[1]),obb_model_old[2],Visualization.COLORS[3],1.0),
    Visualization.GLFrame,
])
