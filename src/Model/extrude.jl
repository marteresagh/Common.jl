# cells = spigoli di bordo oppure = triangoli che descrivono la forma
# se spigoli di bordo ottengo l'estrusione delle facce esterne della superficie
# se triangoli ottengo il solido chiuso
function extrude(points, cells, size_extrusion)

    dim, n = size(points)
    if dim == 3
        plane = Common.Plane(points)
        V2D = Common.apply_matrix(plane.matrix, points)[1:2, :]
    else
        V2D = copy(points)
    end

    new_points = hcat(Common.add_zeta_coordinates(V2D,0.),Common.add_zeta_coordinates(V2D,size_extrusion))

    if length(cells[1]) == 3 # if all cells are triangles
        boundary_edges = Common.get_boundary_edges(V2D, cells)

        new_triangles = copy(cells)
        for tri in cells
            push!(new_triangles,tri.+n)
        end

        for edge in boundary_edges
            a,b = edge
            push!(new_triangles, [a,b,b+n])
            push!(new_triangles, [b+n,a+n,a])
        end
    elseif length(cells[1]) == 2
        new_triangles = Vector{Int64}[]
        for edge in cells
            a,b = edge
            push!(new_triangles, [a,b,b+n])
            push!(new_triangles, [b+n,a+n,a])
        end
    end


    if dim == 3
        points_final =
            Common.apply_matrix(Common.inv(plane.matrix), new_points)
    else
        points_final = copy(new_points)
    end

    return points_final, new_triangles
end
