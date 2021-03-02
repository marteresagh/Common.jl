function model2graph_edge2edge(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
    M1 = Lar.characteristicMatrix(EV)
	EE = (M1*M1').%2
	R, C, VAL = Common.findnz(EE)
	graph = SimpleGraph(length(EV))
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


function makes_direct(g,s)
	dg = LightGraphs.DiGraph(nv(g))
	parents = zeros(Int, nv(g))
	parents[s] = s
	seen = zeros(Bool, nv(g))
	S = Vector{Int}([s])
	seen[s] = true
	while !isempty(S)
		v = S[end]
		u = 0
		for n in outneighbors(g, v)
			if !seen[n]
				u = n
				break
			end
		end
		if u == 0
			pop!(S)
		else
			seen[u] = true
			push!(S, u)
			parents[u] = v
			add_edge!(dg,v,u)

		end
		for n in outneighbors(g, v)
			if n!=u && parents[v]!=n
				if seen[n]
					add_edge!(dg,v,n)
					break
				end

			end
		end

	end
	return dg
end
