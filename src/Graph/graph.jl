function model2graph_edge2edge(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
    M1 = Lar.characteristicMatrix(EV)
	EE = (M1*M1').%2
	R, C, VAL = Common.findnz(EE)
	graph = SimpleGraph(size(EV,2)) #?? V o EV
	for i in 1:nnz(EE)
		add_edge!(graph,R[i],C[i])
	end
	return graph
end


function model2graph(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
	graph = SimpleGraph(size(V,2))
	for ev in EV
		add_edge!(graph,ev[1],ev[2])
	end
	return graph
end
