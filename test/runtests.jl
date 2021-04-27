using Common
using Test

# fondamental struct
# include("lar.jl")
# include("struct.jl")
# geometry
include("Geometry/affinity.jl")
include("Geometry/boundingbox.jl")
include("Geometry/delaunay.jl")
include("Geometry/fit.jl")
include("Geometry/residual.jl")
include("Geometry/util.jl")
# from LinearAlgebraicRepresentation
include("LAR/boundary.jl")
# include("LAR/struct.jl")
# include("LAR/util.jl")
# model
include("Model/double_verts.jl")
include("Model/getmodel.jl")
include("Model/intersection.jl")
include("Model/tools.jl")
