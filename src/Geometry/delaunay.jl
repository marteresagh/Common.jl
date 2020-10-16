function delaunay_triangulation(points::Lar.Points)
    V = convert(Lar.Points,points')
    mesh = delaunay(V);
    DT = [mesh.simplices[c,:] for c in 1:size(mesh.simplices,1)]
    return DT
end
