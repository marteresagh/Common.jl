using Common
using Visualization
using DataStructures


function larModelProduct(modelOne, modelTwo)
    (V, cells1) = modelOne
    (W, cells2) = modelTwo

    vertices = DataStructures.OrderedDict()
    k = 1
    for j = 1:size(V, 2)
        v = V[:, j]
        for i = 1:size(W, 2)
            w = W[:, i]
            id = [v; w]
            if haskey(vertices, id) == false
                vertices[id] = k
                k = k + 1
            end
        end
    end

    cells = []
    for c1 in cells1
        for c2 in cells2
            cell = []
            for vc in c1
                for wc in c2
                    push!(cell, vertices[[V[:, vc]; W[:, wc]]])
                end
            end
            push!(cells, cell)
        end
    end

    vertexmodel = []
    for v in keys(vertices)
        push!(vertexmodel, v)
    end
    verts = hcat(vertexmodel...)
    cells = [[v for v in cell] for cell in cells]
    return (verts, cells)
end

V = [0 10 10 0 1 9 9 1;0 0 10 10. 1 1 9 9]
FV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
# FV = [[1,2,5],[2,5,6],[2,6,3],[6,3,7],[3,4,7],[4,7,8],[1,4,8],[1,5,8]]
modelOne = (V,FV)
T = [0 3]
FT =  [[1, 2]]
modelTwo = (T,FT)
@time W,FW = larModelProduct(modelOne, modelTwo)
Visualization.VIEW([
    Visualization.GLGrid(W,FW)
])

Visualization.VIEW([
    Visualization.GLLar2gl(W,FW)
])

V = [0 1 1 0 0.5;0 0 1 1. 0.5]
FV = [[1,2,5],[3,5,4],[1,5,4]]
modelOne = (V,FV)
T = [0 3]
FT =  [[1, 2]]
modelTwo = (T,FT)
W,FW = larModelProduct(modelOne, modelTwo)
Visualization.VIEW([
    Visualization.GLLar2gl(W,FW)
])

######### mia estruione
V = [0 10 10 0 1 9 9 1; 0 0 10 10. 1 1 9 9]
FV = [[1,2,5],[2,5,6],[2,6,3],[6,3,7],[3,4,7],[4,7,8],[1,4,8],[1,5,8]]
FV = [[1,2],[2,3],[3,4],[1,4],[5,6],[6,7],[7,8],[8,5]]
@time T,FT = Common.extrude(V, FV, 3.)

Visualization.VIEW([
    Visualization.GLExplode(T,[[f] for f in FT],1.,1.,1.,99,1)...
])



function extrudeSimplicial(model::Common.LAR, pattern)
	V = [model[1][:,k] for k=1:size(model[1],2)]
    FV = model[2]
    d, m = length(FV[1]), length(pattern)
    coords = collect(cumsum(append!([0], abs.(pattern))))
    offset, outcells, rangelimit, i = length(V), [], d*m, 0
    for cell in FV
    	i += 1
        tube = [v+k*offset for k in range(0, length=m+1) for v in cell]
        cellTube = [tube[k:k+d] for k in range(1, length=rangelimit)]
        if i==1 outcells = reshape(cellTube, d, m)
        else outcells = vcat(outcells, reshape(cellTube, d, m)) end
    end
    cellGroups = []
    for i in 1:size(outcells, 2)
        if pattern[i]>0
            cellGroups = vcat(cellGroups, outcells[:, i])
        end
    end
    outVertices = [vcat(v, [z]) for z in coords for v in V]
    cellGroups = convert(Array{Array{Int, 1}, 1}, cellGroups)
    outModel = outVertices, cellGroups
    hcat(outVertices...), cellGroups
end

V = [0 10 10 0 1 9 9 1;0 0 10 10. 1 1 9 9]
FV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]

Visualization.VIEW([Visualization.GLGrid(V,FV)])
pattern = repeat([1,2,-3],outer=1)
model = (V,FV);
@time W,FW = extrudeSimplicial(model, pattern)
Visualization.VIEW([Visualization.GLGrid(W,FW)])
