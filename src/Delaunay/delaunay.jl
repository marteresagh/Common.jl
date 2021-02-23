"""
    delaunay_triangulation(points::Lar.Points) -> Lar.Cells

Delaunay triangulation of points in d-dimensional Euclidean space.
Lar interface of Delaunay.jl.
"""
function delaunay_triangulation(points::Lar.Points)::Lar.Cells
    centroid = Common.centroid(points)
    T = Common.apply_matrix(Lar.t(-centroid...),points)
    V = convert(Lar.Points,T')
    mesh = delaunay(V);
    DT = [mesh.simplices[c,:] for c in 1:size(mesh.simplices,1)]
    return sort.(DT)
end


"""
    delaunay_triangulation(points::Lar.Points) -> Lar.Cells

Delaunay triangulation of points in d-dimensional Euclidean space.
Lar interface of Delaunay.jl.
"""
function LinearAlgebraicRepresentation.triangulate2d(V::Lar.Points, EV::Lar.Cells)
    # data for Constrained Delaunay Triangulation (CDT)
    points = convert(Array{Float64,2}, V')
	points_map = Array{Int64,1}(collect(1:1:size(points)[1]))
    edges_list = convert(Array{Int64,2}, hcat(EV...)')
    edge_boundary = [true for k=1:size(edges_list,1)] ## dead code !!

	triin=Triangulate.TriangulateIO()
	triin.pointlist=V
	triin.segmentlist=hcat(EV...)
	(triout, vorout)=triangulate("pcQ", triin)
	trias = Array{Int64,1}[c[:] for c in eachcol(triout.trianglelist)]
 	#Triangle.constrained_triangulation(points,points_map,edges_list)

	innertriangles = Array{Int64,1}[]
	for (u,v,w) in trias
		point = (points[u,:]+points[v,:]+points[w,:])./3
		copEV = Lar.lar2cop(EV)
		inner = Lar.point_in_face(point, points::Lar.Points, copEV::Lar.ChainOp)
		if inner
			push!(innertriangles,[u,v,w])
		end
	end
    return innertriangles
end


triin=Triangulate.TriangulateIO()
triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
(triout, vorout)=triangulate("pcQ", triin)
display(triout)
