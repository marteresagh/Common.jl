"""
    delaunay_triangulation(points::Lar.Points) -> Lar.Cells

Delaunay triangulation of points in d-dimensional Euclidean space.
"""
function delaunay_triangulation(points::Lar.Points)::Lar.Cells
    centroid = centroid(points)
    T = Common.apply_matrix(Lar.t(-centroid...),points)
    V = convert(Lar.Points,T')
    mesh = delaunay(V);
    DT = [mesh.simplices[c,:] for c in 1:size(mesh.simplices,1)]
    return sort.(DT)
end
