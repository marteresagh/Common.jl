"""
	removeDups(CW::Cells)::Cells

Remove dublicate `cells` from `Cells` object. Then put `Cells` in *canonical form*, i.e. with *sorted indices* of vertices in each (unique) `Cells` Array element.
"""
function removeDups(CW::Cells)::Cells
	CW = collect(Set(CW))
	CWs = collect(map(sort,CW))
	return CWs
end

"""
	struct2lar(structure::Struct)::Union{LAR,LARmodel}

"""
function struct2lar(structure) # TODO: extend to true `LARmodels`
	listOfModels = evalStruct(structure)
	vertDict= Dict()
	index,defaultValue = 0,0
	W = Array{Float64,1}[]
	m = length(listOfModels[1])
	larmodel = [Array{Number,1}[] for k=1:m]

	for model in listOfModels
		V = model[1]
		for k=2:m
			for incell in model[k]
				outcell=[]
				for v in incell
					key = map(approxVal(7), V[:,v])
					if get(vertDict,key,defaultValue)==defaultValue
						index += 1
						vertDict[key]=index
						push!(outcell,index)
						push!(W,key)
					else
						push!(outcell,vertDict[key])
					end
				end
				append!(larmodel[k],[outcell])
			end
		end
	end

	append!(larmodel[1], W)
	V = hcat(larmodel[1]...)
	chains = [convert(Cells, chain) for chain in larmodel[2:end]]
	return (V, chains...)
end

"""
	embedTraversal(cloned::Struct,obj::Struct,n::Int,suffix::String)

# TODO:  debug embedTraversal
"""
function embedTraversal(cloned::Struct,obj::Struct,n::Int,suffix::String)
	for i=1:length(obj.body)
		if isa(obj.body[i],Matrix)
			mat = obj.body[i]
			d,d = size(mat)
			newMat = Matrix{Float64}(LinearAlgebra.I, d+n, d+n)
			for h in range(1, length=d)
				for k in range(1, length=d)
					newMat[h,k]=mat[h,k]
				end
			end
			push!(cloned.body,[newMat])
		elseif (isa(obj.body[i],Tuple) ||isa(obj.body[i],Array))&& length(obj.body[i])==3
			V,FV,EV = deepcopy(obj.body[i])
			dimadd = n
			ncols = size(V,2)
			nmat = zeros(dimadd,ncols)
			V = [V;zeros(dimadd,ncols)]
			push!(cloned.body,[(V,FV,EV)])
		elseif  (isa(obj.body[i],Tuple) ||isa(obj.body[i],Array))&& length(obj.body[i])==2
			V,EV = deepcopy(obj.body[i])
			dimadd = n
			ncols = size(V,2)
			nmat = zeros(dimadd,ncols)
			V = [V;zeros(dimadd,ncols)]
			push!(cloned.body,[(V,EV)])
		elseif isa(obj.body[i],Struct)
			newObj = Struct()
			newObj.box = [ [obj.body[i].box[1];zeros(dimadd)],
							[obj.body[i].box[2];zeros(dimadd)] ]
			newObj.category = (obj.body[i]).category
			push!(cloned.body,[embedTraversal(newObj,obj.body[i],obj.dim+n,suffix)])
		end
	end
	return cloned
end

"""
	embedStruct(n::Int)(self::Struct,suffix::String="New")

# TODO:  debug embedStruct
"""
function embedStruct(n::Int)
	function embedStruct0(self::Struct,suffix::String="New")
		if n==0
			return self, length(self.box[1])
		end
		cloned = Struct()
		cloned.box = [ [self.body[i].box[1];zeros(dimadd)],
						[self.body[i].box[2];zeros(dimadd)] ]
		cloned.name = self.name*suffix
		cloned.category = self.category
		cloned.dim = self.dim+n
		cloned = embedTraversal(cloned,self,n,suffix)
		return cloned
	end
	return embedStruct0
end

"""
	box(model)

"""
function box(model)
	if isa(model,Matrix)
		return nothing
	elseif isa(model,Struct)
		listOfModels = evalStruct(model)
		#dim = checkStruct(listOfModels)
		if listOfModels == []
			return model.box
		else
			theMin,theMax = box(listOfModels[1])
			for theModel in listOfModels[2:end]
				modelMin,modelMax= box(theModel)
				for (k,val) in enumerate(modelMin)
					if val < theMin[k]
						theMin[k]=val
					end
				end
				for (k,val) in enumerate(modelMax)
					if val > theMax[k]
						theMax[k]=val
					end
				end
			end
		end
		return [theMin,theMax]

	elseif (isa(model,Tuple) ||isa(model,Array))&& (length(model)>=2)
		V = model[1]
		theMin = minimum(V, dims=2)
		theMax = maximum(V, dims=2)
	end

	return [theMin,theMax]
end

"""
	apply(affineMatrix::Array{Float64,2}, larmodel::Union{LAR,LARmodel})
"""
function apply(affineMatrix, larmodel)
	data = collect(larmodel)
	V = data[1]

	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	V = (affineMatrix * W)[1:m,1:n]

	data[1] = V
	larmodel = Tuple(data)
	return larmodel
end


"""
	checkStruct(lst)

"""
function checkStruct(lst)
	obj = lst[1]
	if isa(obj,Matrix)
		dim = size(obj,1)-1
	elseif (isa(obj,Tuple) || isa(obj,Array))
		dim = length(obj[1][:,1])

	elseif isa(obj,Struct)
		dim = length(obj.box[1])
	end
	return dim
end

"""
	traversal(CTM,stack,obj,scene=[])

"""
function traversal(CTM::Matrix, stack, obj, scene=[])
	for i = 1:length(obj.body)
		if isa(obj.body[i],Matrix)
			CTM = CTM*obj.body[i]
		elseif (isa(obj.body[i],Tuple) || isa(obj.body[i],Array)) &&
			(length(obj.body[i])>=2)
			l = apply(CTM, obj.body[i])
			push!(scene,l)
		elseif isa(obj.body[i],Struct)
			push!(stack,CTM)
			traversal(CTM,stack,obj.body[i],scene)
			CTM = pop!(stack)
		end
	end
	return scene
end

"""
	evalStruct(self)

"""
function evalStruct(self::Struct)
	dim = checkStruct(self.body)
   	CTM, stack = Matrix{Float64}(LinearAlgebra.I, dim+1, dim+1), []
   	scene = traversal(CTM, stack, self, [])
	return scene
end
