function graph_edge2edge(V,EV)
    M1 = Lar.characteristicMatrix(EV)
	EE = (M1*M1').%2
	R, C, VAL = Common.findnz(EE)
	graph = SimpleGraph(size(V,2))
	for i in 1:nnz(EE)
		add_edge!(graph,R[i],C[i])
	end
	return graph
end
