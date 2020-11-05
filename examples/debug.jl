using Visualization
using Common

npoints = 1000
xslope = 0.5
yslope = 0.
off = 1.

xs = 3*rand(npoints)
ys = Float64[]


for i in 1:npoints
    push!(ys, xs[i]*xslope + off + 0.01*rand()) # points perturbation
end

points = convert(Lar.Points, hcat(xs,ys)')

# fit
dir,cen = Common.LinearFit(points)
V,EV = Common.DrawLine(Hyperplane(PointCloud(points),dir,cen))

y = points[2,:]
x = vcat(points[1,:]',zeros(size(points,2))')
f = hcat([dir*(Lar.dot(dir,points[:,i]-cen))+cen for i in 1:npoints]...)


GL.VIEW([
    	GL.GLPoints(convert(Lar.Points,f'),GL.COLORS[6])
	GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	GL.GLGrid(V,EV)
	GL.GLFrame2
]);
