using Common, Visualization

# input generation
npoints = 1000
xslope = 0.5
yslope = 0.
off = 1.

xs = 3*rand(npoints)
ys = 4*rand(npoints)
zs = Float64[]

for i in 1:npoints
    push!(zs, xs[i]*xslope + ys[i]*yslope + off + rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys,zs)')

# fit
params3D = Common.LinearFit(points)
aabb = Common.boundingbox(points)
V,FV = Common.DrawPlane(Hyperplane(params3D...),aabb)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[6])
	GL.GLGrid(V,FV)
	GL.GLAxis(GL.Point3d(0,0,0),GL.Point3d(1,1,1))
]);


# input generation
xs = 3*rand(npoints)
ys = Float64[]


for i in 1:npoints
    push!(ys, xs[i]*xslope + off + 0*rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys)')

# fit
params2D = Common.LinearFit(points)
V,EV = DrawLine(Hyperplane(PointCloud(points),params2D...))

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[6])
	GL.GLGrid(V,EV)
	GL.GLAxis(GL.Point3d(0,0,0),GL.Point3d(1,1,1))
]);
