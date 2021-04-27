using Common
using LightGraphs

V = [0 6 8 8 8 0 5.;
    0 0 0 1 4 4 3]
EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[2,4],[4,7],[7,2]]

GL.VIEW([
    GL.GLGrid(V,EV)
])

cycles = Common.get_cycles(V,EV)

GL.VIEW([
    GL.GLGrid(w,EW, GL.COLORS[1])
    GL.GLGrid(w,EW[cycles[4]], GL.COLORS[rand(2:12)])
])
