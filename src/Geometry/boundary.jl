function K( CV )
	I = vcat( [ [k for h in CV[k]] for k=1:length(CV) ]...)
	J = vcat(CV...)
	Vals = [1 for k=1:length(I)]
	return sparse(I,J,Vals)
end

function FV2EV( v )
	edges = [
		[v[1], v[2]], [v[1], v[3]], [v[2], v[3]]]
end

function CV2FV( v )
	faces = [
		[v[1], v[2], v[3], v[4]], [v[5], v[6], v[7], v[8]],
		[v[1], v[2], v[5], v[6]], [v[3], v[4], v[7], v[8]],
		[v[1], v[3], v[5], v[7]], [v[2], v[4], v[6], v[8]]]
end

function CV2EV( v )
	edges = [
		[v[1], v[2]], [v[3], v[4]], [v[5], v[6]], [v[7], v[8]], [v[1], v[3]], [v[2], v[4]],
		[v[5], v[7]], [v[6], v[8]], [v[1], v[5]], [v[2], v[6]], [v[3], v[7]], [v[4], v[8]]]
end



function get_boundary_edges(V::Lar.Points,FV::Lar.Cells)
	EV = convert(Array{Array{Int64,1},1}, collect(Set(cat(map(FV2EV,FV)))))

	# M_0 = K(VV)
	M_1 = K(EV)
	M_2 = K(FV)

	# ∂_1 = M_0 * M_1'
	∂_2 = (M_1 * M_2') .÷ 2 #	.÷ sum(M_1,dims=2)
	# s = sum(M_2,dims=2)
	# ∂_3 = (M_2 * M_3')
	# ∂_3 = ∂_3 ./	s
	# ∂_3 = ∂_3 .÷ 1	#	.÷ sum(M_2,dims=2)

	S1 = sum(∂_2,dims=2)
	inner = [k for k=1:length(S1) if S1[k]==2]
	outer = setdiff(collect(1:length(EV)), inner)
	return EV[outer]
end
