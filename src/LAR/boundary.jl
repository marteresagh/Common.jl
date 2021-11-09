function CAT(args)
	return reduce( (x,y) -> append!(x,y), args; init=[] )
end

function characteristicMatrix( CV )::ChainOp
	I = vcat( [ [k for h in CV[k]] for k=1:length(CV) ]...)
	J = vcat(CV...)
	Vals = [1 for k=1:length(I)]
	return sparse(I,J,Vals)
end

function FV2EV( v )
	edges = [[v[1], v[2]], [v[1], v[3]], [v[2], v[3]]]
end

function CV2FV( v )
	faces = [[v[1], v[2], v[3], v[4]], [v[5], v[6], v[7], v[8]],
		[v[1], v[2], v[5], v[6]], [v[3], v[4], v[7], v[8]],
		[v[1], v[3], v[5], v[7]], [v[2], v[4], v[6], v[8]]]
end

function CV2EV( v )
	edges = [[v[1], v[2]], [v[3], v[4]], [v[5], v[6]], [v[7], v[8]], [v[1], v[3]], [v[2], v[4]],
			[v[5], v[7]], [v[6], v[8]], [v[1], v[5]], [v[2], v[6]], [v[3], v[7]], [v[4], v[8]]]
end

function get_boundary_points(V::Points,EV::Cells)
	M_2 = characteristicMatrix(EV)

	S1 = sum(M_2',dims=2)

	outer = [k for k=1:length(S1) if S1[k]==1]
	return outer
end

function get_boundary_edges(V::Points,FV::Cells)
	EV = convert(Array{Array{Int64,1},1}, collect(Set(CAT(map(FV2EV,FV)))))

	M_1 = characteristicMatrix(EV)
	M_2 = characteristicMatrix(FV)

	∂_2 = (M_1 * M_2') .÷ 2

	S1 = sum(∂_2,dims=2)

	outer = [k for k=1:length(S1) if S1[k]==1]
	return EV[outer]
end

function get_boundary_faces(V::Points,CV::Cells)
	FV = convert(Array{Array{Int64,1},1}, collect(Set(CAT(map(CV2FV,CV)))))

	M_2 = characteristicMatrix(FV)
	M_3 = characteristicMatrix(CV)

	s = sum(M_2,dims=2)
	∂_3 = (M_2 * M_3')
	∂_3 = ∂_3 ./ s
	∂_3 = ∂_3 .÷ 1	#	.÷ sum(M_2,dims=2)

	S2 = sum(∂_3,dims=2)
	inner = [k for k=1:length(S2) if S2[k]==2]
	outer = setdiff(collect(1:length(FV)), inner)
	return FV[outer]
end
