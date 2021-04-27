using Common, Visualization

# input generation ==================================================== PLANE
npoints = 1000
xslope = rand()
yslope = -rand()
off = 1.

xs = 3*rand(npoints)
ys = 4*rand(npoints)
zs = Float64[]

for i in 1:npoints
    push!(zs, xs[i]*xslope + ys[i]*yslope + off + 0.0*rand()) # points perturbation
end

points = vcat(xs',ys',zs')

# fit
params3D = Common.LinearFit(points)
aabb = Common.boundingbox(points)
plane = Plane(params3D[1],params3D[2])
points_flat = Common.apply_matrix(plane.matrix,points)

V,FV = Common.DrawPlanes(plane, Common.boundingbox(points))

Visualization.VIEW([
	Visualization.points(points; color = Visualization.COLORS[6])
	Visualization.points(points_flat; color = Visualization.COLORS[1])
	Visualization.GLGrid(V,FV)
	Visualization.axis_helper(Common.inv(plane.matrix); x_color=Visualization.COLORS[6],y_color=Visualization.COLORS[7],z_color=Visualization.COLORS[5] )
	Visualization.axis_helper()
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

points = vcat(xs',ys')
outlier = hcat(points,[4,5])
# fit
# params2D = Common.LinearFit(outlier)
V,EV = Common.DrawLines(Line(outlier))
hyperplane = Hyperplane(PointCloud(outlier),params2D...)
Visualization.VIEW([
    Visualization.points(outlier; color = Visualization.COLORS[6])
	Visualization.GLGrid(V,EV)
	Visualization.GLFrame2
]);


# input generation ==================================================== CIRCLE
npoints = 10
radius = 3.
center = [3.,2.]

xs = Float64[]
ys = Float64[]

for i in 1:npoints
	angle = 2*pi*rand()
	push!(xs, radius*cos(angle)+0.1*rand())
    push!(ys, radius*sin(angle)+0.1*rand()) # points perturbation
end

points = Common.apply_matrix(Common.t(center...),vcat(xs',ys'))

# fit
params2D = Common.Fit_Circle(points)

# circle = Hypersphere(PointCloud(points),params2D...)
#
# Visualization.VIEW([
#     Visualization.GLPoints(convert(Lar.Points,points'),Visualization.COLORS[6])
# 	Visualization.mesh_circles([circle])...
# 	Visualization.GLFrame2
# ]);
