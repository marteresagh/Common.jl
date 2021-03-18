using Common
using Visualization


V = [1. 2. 1. 2. 1. 2. 1. 2.;
    1. 1. 2. 2. 1. 1. 2. 2.;
    1. 1. 1. 1. 5. 5. 5. 5.]

obb = Common.ch_oriented_boundingbox(V)

obb2 = Common.oriented_boundingbox(V)

vol1 = getmodel(obb)
vol2 = getmodel(obb2)

GL.VIEW([
    GL.GLPoints(permutedims(V)),
    GL.GLGrid(vol1[1],vol1[2], GL.WHITE),
    GL.GLGrid(vol2[1],vol2[2], GL.GREEN)
])
