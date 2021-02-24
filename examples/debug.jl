using Common
using Visualization

V = rand(2,10)

FV = Common.delaunay_triangulation(V)

EV = Common.get_boundary_edges(V::Lar.Points,FV::Lar.Cells)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,V'),GL.COLORS[6])
	GL.GLGrid(V,EV)
])


trias = Lar.triangulate2d(V,EV)


# triin=Triangulate.TriangulateIO()
# triin.pointlist=V
# triin.segmentlist=hcat(EV...)
# (triout, vorout)=triangulate("pcQ", triin)
# trias = Array{Int64,1}[c[:] for c in eachcol(triout.trianglelist)]

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,V'),GL.COLORS[6])
	GL.GLGrid(V,convert(Array{Array{Int64,1},1}, collect(Set(Common.CAT(map(Common.FV2EV,trias)))))
)
])
