using Visualization
using Common

npoints = 1000
xslope = 0.5
yslope = 0.
off = 1.

xs = 3*rand(npoints)
ys = 10*rand(npoints)
zs = Float64[]

for i in 1:npoints
    push!(zs, xs[i]*xslope + ys[i]*yslope + off + 0.01*rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys,zs)')

# fit
direction,centroid = Common.LinearFit(points)


plane = Common.Plane(direction...,Lar.dot(direction,centroid))

T = Common.apply_matrix(Lar.inv(plane.matrix),points)


V,(VV,EV,FV) = Lar.cuboid([1,1],true)
V3D = vcat(V,zeros(size(V,2))')

GL.VIEW([
        Visualization.points(points),
        Visualization.points(T, GL.COLORS[2]),
        GL.GLGrid(V3D,EV, GL.COLORS[2],1.),
        GL.GLFrame
])


W = Common.apply_matrix(plane.matrix,V3D)

GL.VIEW([
        Visualization.points(points),
        Visualization.points(T, GL.COLORS[2]),
        GL.GLGrid(V,EV, GL.COLORS[2]),
        GL.GLGrid(W,EV, GL.COLORS[12]),
        GL.GLFrame
])
