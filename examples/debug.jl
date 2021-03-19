using Common
using Visualization

points = [1. 1. 2. 2.;
        1. 2. 1. 2.;
        0.1 0.01 -0.01 0.]
params = Common.LinearFit(points)
plane1 = Hyperplane(PointCloud(points),params...)
V,EV,FV = Common.DrawPlanes(plane1; box_oriented=true)

box = Common.boundingbox(points)
box = Common.ch_oriented_boundingbox(points)
box_V,box_EV,box_FV = getmodel(box)
GL.VIEW([GL.GLPoints(permutedims(points)),GL.GLGrid(V,FV)])
