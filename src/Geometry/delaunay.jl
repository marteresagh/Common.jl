"""
    delaunay_triangulation(points::Points) -> Cells

Delaunay triangulation of points in d-dimensional Euclidean space.
"""
function delaunay_triangulation(points::Points)::Cells
    # TODO per il 2D usiamo Triangulate
    centroid = Common.centroid(points)
    T = apply_matrix(Common.t(-centroid...), points)
    V = permutedims(T)
    mesh = delaunay(V)
    DT = [mesh.simplices[c, :] for c = 1:size(mesh.simplices, 1)]
    return sort.(DT)
end

"""
    constrained_triangulation2D(V::Points, EV::Cells) -> Cells

Constrained Delaunay Triangulation (CDT) of points in 2D Euclidean space.
Lar interface of Triangulate.jl.
"""
function constrained_triangulation2D(V::Points, EV::Cells)
	triin = Triangulate.TriangulateIO()
	triin.pointlist = V
	triin.segmentlist = hcat(EV...)
	(triout, vorout) = triangulate("pQ", triin)
	trias = Array{Int64,1}[c[:] for c in eachcol(triout.trianglelist)]
	return trias
end


"""
 	LinearAlgebraicRepresentation.triangulate2d(V::Points, EV::Cells)

@overwrite Common.triangulate2d.
"""
function constrained_triangulation_with_holes2D(V::Points, EV::Cells)
    # data for Constrained Delaunay Triangulation (CDT)
    points = permutedims(V)
	trias = constrained_triangulation2D(V::Points, EV::Cells)

	innertriangles = Array{Int64,1}[]
	for (u,v,w) in trias
		point = (points[u,:]+points[v,:]+points[w,:])./3
		copEV = lar2cop(EV)
		inner = point_in_face(point, points::Points, copEV::ChainOp)
		if inner
			push!(innertriangles,[u,v,w])
		end
	end
    return innertriangles
end

# 
# """
#     constrained_triangulation2D(V::Points, EV::Cells) -> Cells
#
# Constrained Delaunay Triangulation (CDT) of points in 2D Euclidean space.
# Lar interface of Triangulate.jl.
# """
# function constrained_triangulation3D(V::Points, FV::Cells)
# 	tetras = delaunay_triangulation(V)
# 	return trias
# end
