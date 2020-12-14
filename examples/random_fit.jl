using Common, Visualization

# input generation ==================================================== PLANE
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


# input generation ==================================================== LINE
npoints = 500
xslope = 0.5
off = 1.

xs = 3*rand(npoints)
ys = Float64[]


for i in 1:npoints
    push!(ys, xs[i]*xslope + off + 0.1*rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys)')
outlier = hcat(points,[4,5])
# fit
params2D = Common.LinearFit(outlier)

hyperplane = Hyperplane(PointCloud(outlier),params2D...)
GL.VIEW([
    GL.GLPoints(convert(Lar.Points,outlier'),GL.COLORS[6])
	Visualization.mesh_lines([hyperplane])...
	GL.GLFrame2
]);


# input generation ==================================================== CIRCLE
npoints = 500
radius = 3.


xs = Float64[]
ys = Float64[]


for i in 1:npoints
	angle = 2*pi*rand()
	push!(xs, radius*cos(angle)+0.1*rand())
    push!(ys, radius*sin(angle)+0.1*rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys)')

# fit
params2D = Common.Fit_Circle(points)

circle = Hypersphere(PointCloud(points),params2D...)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[6])
	# Visualization.mesh_lines([hyperplane])...
	GL.GLFrame2
]);
