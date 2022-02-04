using Common
using Visualization
using Detection
using PyCall


function DrawPlanes(
    planes::Array{Detection.Plane,1},
    AABB::Common.AABB,
)::Common.LAR
    out = Array{Common.Struct,1}()
    for plane in planes
        cell = Common.getmodel(plane, AABB)
        push!(out, Common.Struct([cell]))
    end
    out = Common.Struct(out)
    V, EV, FV = Common.struct2lar(out)
    return V, EV, FV
end
function DrawPlanes(plane::Detection.Plane, AABB)
    return DrawPlanes([plane], AABB)
end

function extrude(V, EV, FV, size_extrusion)
    dim, n = size(V)
    if dim == 3
        plane = Common.Plane(V)
        V2D = Common.apply_matrix(plane.matrix, V)[1:2, :]
    else
        V2D = copy(V)
    end

    new_points = hcat(
        Common.add_zeta_coordinates(V2D, -size_extrusion / 2),
        Common.add_zeta_coordinates(V2D, size_extrusion / 2),
    )

    if dim == 3
        V_extruded = Common.apply_matrix(Common.inv(plane.matrix), new_points)
    else
        V_extruded = copy(new_points)
    end

    EV_extruded = [
        EV...,
        [[i, i + n] for i = 1:n]...,
        [map(x -> x + n, edge) for edge in EV]...,
    ]

    FV_extruded = [
        FV...,
        [[edge[1], edge[2], edge[2] + n, edge[1] + n] for edge in EV]...,
        [map(x -> x + n, face) for face in FV]...,
    ]

    return V_extruded, EV_extruded, FV_extruded
end


points = rand(3, 100000)
function point_in_poly(delaunay_model, point)

    py"""
    from scipy.spatial import Delaunay

    def py_point_in_poly(delaunay_model,point):
        simplices = delaunay_model.find_simplex(point)
        return simplices
    """
    check = py"py_point_in_poly"(delaunay_model, point)
    return check[1] > 0
end

function delaunay(V)
    py"""
    from scipy.spatial import Delaunay
    import numpy as np

    def get_delaunay(poly):
        poly = np.array(poly)
        return Delaunay(poly)

    """

    return py"get_delaunay"([c[:] for c in eachcol(V)])
end

plane = Plane(rand(3), rand(3))

aabb = Common.AABB(1, 0, 1, 0, 1, 0.0)

V, EV, FV = DrawPlanes(plane, aabb)
FV = [[1, 2, 3, 4, 5]]
V, EV, FV = extrude(V, EV, FV, 0.05)

delaunay_model = delaunay(V)

clipped = []
@btime for i = 1:size(points, 2)
    p = points[:, i]
    if Common.point_in_polyhedron(p, V, EV, FV)
        push!(clipped, p)
    end
end

clipped_points = hcat(clipped...)

clipped = []
@btime for i = 1:size(points, 2)
    p = points[:, i]
    if point_in_poly(delaunay_model, p)
        push!(clipped, p)
    end
end

clipped_points = hcat(clipped...)

Visualization.VIEW([
    Visualization.points(points)
    Visualization.points(clipped_points; color = Visualization.COLORS[2])
    Visualization.GLGrid(V, FV, Visualization.COLORS[2])
])
