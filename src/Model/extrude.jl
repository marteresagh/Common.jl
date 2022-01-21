# cells = spigoli di bordo oppure = triangoli che descrivono la forma
# se spigoli di bordo ottengo l'estrusione delle facce esterne della superficie
# se triangoli ottengo il solido chiuso
function extrude(points::Points, cells::Cells, size_extrusion::Float64)

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

# ESTRUSIONE CENTRATA
# function extrude(V, EV, FV, size_extrusion)
#     dim, n = size(V)
#     if dim == 3
#         plane = Common.Plane(V)
#         V2D = Common.apply_matrix(plane.matrix, V)[1:2, :]
#     else
#         V2D = copy(V)
#     end
#
#     new_points = hcat(Common.add_zeta_coordinates(V2D,-size_extrusion/2),Common.add_zeta_coordinates(V2D,size_extrusion/2))
#
#     if dim == 3
#         V_extruded =
#             Common.apply_matrix(Common.inv(plane.matrix), new_points)
#     else
#         V_extruded = copy(new_points)
#     end
#
#     EV_extruded = [EV..., [[i,i+n] for i in 1:n]..., [map(x->x+n,edge) for edge in EV]...]
#
#     FV_extruded = [FV..., [[edge[1],edge[2],edge[2]+n,edge[1]+n] for edge in EV]..., [map(x->x+n,face) for face in FV]...]
#
#     return V_extruded, EV_extruded, FV_extruded
# end
