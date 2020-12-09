using Common
using Visualization


volume = Volume([1,1.,1],[0,0,0.],[0.,0,0])
model = Common.volume2LARmodel(volume)
aabb = AABB(0.5,-0.5,0.5,-0.5,0.5,-0.5)
T,ET,FT = getmodel(aabb)

plane = Plane(0,1,0,0)
normal = [0,1.,0]
centroid = normal*0
rot = Matrix(Common.orthonormal_basis(0,1.,0)')
matrix = Common.matrix4(rot)
matrix[1:3,4] = centroid
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
