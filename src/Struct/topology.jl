"""
	Cells -> Array{Array{Int,1},1}

Alias declation of LAR-specific data structure.
Dense `Array` to store the indices of vertices of `P-cells`
of a cellular complex.
The linear space of `P-chains` is generated by `Cells` as a basis.
Simplicial `P-chains` have ``P+1`` vertex indices for `cell` element in `Cells` array.
Cuboidal `P-chains` have ``2^P`` vertex indices for `cell` element in `Cells` array.
Other types of chain spaces may have different numbers of vertex indices for `cell`
element in `Cells` array.
"""
const Cells = Array{Array{Int,1},1}
const Cell = SparseVector{Int8, Int}


"""
	Chain -> SparseArrays.SparseVector{Int8,Int}

Alias declation of LAR-specific data structure.
Binary `SparseVector` to store the coordinates of a `chain` of `N-cells`. It is
`nnz=1` with `value=1` for the coordinates of an *elementary N-chain*, constituted by
a single *N-chain*.
"""
const Chain = SparseArrays.SparseVector{Int8,Int}


"""
	ChainOp -> SparseArrays.SparseMatrixCSC{Int8,Int}

Alias declation of LAR-specific data structure.
`SparseMatrix` in *Compressed Sparse Column* format, contains the coordinate
representation of an operator between linear spaces of `P-chains`.
Operators ``P-Boundary : P-Chain -> (P-1)-Chain``
and ``P-Coboundary : P-Chain -> (P+1)-Chain`` are typically stored as
`ChainOp` with elements in ``{-1,0,1}`` or in ``{0,1}``, for
*signed* and *unsigned* operators, respectively.
"""
const ChainOp = SparseArrays.SparseMatrixCSC{Int8,Int}


"""
	ChainComplex -> Array{ChainOp,1}

Alias declation of LAR-specific data structure. It is a
1-dimensional `Array` of `ChainOp` that provides storage for either the
*chain of boundaries* (from `D` to `0`) or the transposed *chain of coboundaries*
(from `0` to `D`), with `D` the dimension of the embedding space, which may be either
``R^2`` or ``R^3``.
"""
const ChainComplex = Array{ChainOp,1}


"""
	LARmodel -> Tuple{Points,Array{Cells,1}}

Alias declation of LAR-specific data structure.
`LARmodel` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
`Points`, and *Topology* is stored as `Array` of `Cells`. The number of `Cells`
values may vary from `1` to `N+1`.
"""
const LARmodel = Tuple{Points,Array{Cells,1}}


"""
	LAR -> Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }

Alias declation of LAR-specific data structure.
`LAR` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
`Points`, and *Topology* is stored as `Cells`.
"""
const LAR = Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }

"""
	Struct

A *container* of geometrical objects is defined by applying the function `Struct` to
the array of contained objects. Each value is defined in local coordinates and may be transformed by affine transformation tensors.

The value returned from the application of `Struct` to an `Array{Any, 1}` of `LAR` values, `matrices`, and `Struct` values is a value of
`Struct type`.  The coordinate system of this value is the one associated with the first object of the `Struct` arguments.  Also,
the resulting geometrical value is often associated with a variable name.

The generation of containers may continue hierarchically by suitably applying `Struct`. Notice that each LAR object in a `Struct` container is transformed by each matrix before it *within the container*, going from right to left. The action of a transformation (tensor) extends to each object on its right within its own container. Whereas,  the action of a tensor does not extend outside its container, according to the semantics of *PHIGS* structures.

# Example

```julia
julia> L = LinearAlgebraicRepresentation;

julia> assembly = L.Struct([L.sphere()(), L.t(3,0,-1), L.cylinder()()])
# return
Struct(Any[([0.0 -0.173648 … -0.336824 -0.17101; 0.0 0.0 … 0.0593912 0.0301537;
-1.0 -0.984808 … 0.939693 0.984808], Array{Int64,1}[[2, 3, 1], [4, 2, 3], [4, 3, 5], [4,
5, 6], [7, 5, 6], [7, 8, 6], [7, 9, 8], … , [1.0 0.0 0.0 3.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0
-1.0; 0.0 0.0 0.0 1.0], ([0.5 0.5 … 0.492404 0.492404; 0.0 0.0 … -0.0868241 -0.0868241;
0.0 2.0 … 0.0 2.0], Array{Int64,1}[[4, 2, 3, 1], [4, 3, 5, 6], [7, 5, 8, 6], [7, 9, 10,
8], [9, 10, 11, 12], [13, 14, 11, 12], … , [68, 66, 67, 65], [68, 69, 67, 70], [71, 69,
72, 70], [71, 2, 72, 1]])], Array{Float64,2}[[-1.0; -1.0; -1.0], [3.5; 1.0; 1.0]],
"14417445522513259426", 3, "feature")

julia> assembly.name = "simple example"
# return
"simple example"

julia> assembly
# return
Struct(Any[([0.0 -0.173648 … -0.336824 -0.17101; 0.0 0.0 … 0.0593912 0.0301537;
-1.0 -0.984808 … 0.939693 0.984808], Array{Int64,1}[[2, 3, 1], [4, 2, 3], [4, 3, 5], [4,
5, 6], [7, 5, 6], [7, 8, 6], … , [71, 2, 72, 1]])], Array{Float64,2}[[-1.0; -1.0; -1.0],
[3.5; 1.0; 1.0]], "simple example", 3, "feature")

julia> using Plasm

julia> Plasm.view(assembly)
```
"""
mutable struct Struct
	body::Array
	box
	name::AbstractString
	dim
	category::AbstractString

	function Struct()
		self = new([],Any,"new",Any,"feature")
		self.name = string(objectid(self))
		return self

	end

	function Struct(data::Array)
		self = Struct()
		self.body = data
		self.box = box(self)
		self.dim = length(self.box[1])
		return self
	end

	function Struct(data::Array,name)
		self = Struct()
		self.body=[item for item in data]
		self.box = box(self)
		self.dim = length(self.box[1])
		self.name = string(name)
		return self
	end

	function Struct(data::Array,name,category)
		self = Struct()
		self.body = [item for item in data]
		self.box = box(self)
		self.dim = length(self.box[1])
		self.name = string(name)
		self.category = string(category)
		return self
	end

	function name(self::Struct)
		return self.name
	end

	function category(self::Struct)
		return self.category
	end

	function len(self::Struct)
		return length(self.body)
	end

	function getitem(self::Struct,i::Int)
		return self.body[i]
	end

	function setitem(self::Struct,i,value)
		self.body[i]=value
	end

	function pprint(self::Struct)
		return "<Struct name: $(self.name)"
	end

	function set_name(self::Struct,name)
		self.name = string(name)
	end

	function clone(self::Struct,i=0)
		newObj = deepcopy(self)
		if i!=0
			newObj.name="$(self.name)_$(string(i))"
		end
		return newObj
	end

	function set_category(self::Struct,category)
		self.category = string(category)
	end

end
