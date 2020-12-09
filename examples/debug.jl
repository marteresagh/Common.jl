using Common
using Visualization


volume = Volume([1,1.,1],[0,0,0.],[0.,0,0])
model = Common.volume2LARmodel(volume)
aabb = AABB(0.5,-0.5,0.5,-0.5,0.5,-0.5)
T,ET,FT = getmodel(aabb)

plane = Plane(0,0,1,0)
model = Common.plane2model(plane, 1., aabb)
matrix = Common.box_new_coords_system(model)
V,EV,FV = model

GL.VIEW(
    [
    GL.GLGrid(V,EV),
    #GL.GLGrid(T,ET),
    Visualization.helper_axis(Common.matrix4(matrix))...,
    #GL.GLFrame
    ]
)
