@testset "Graph" begin

	@testset "model2graph_edge2edge" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
		graph = Common.model2graph_edge2edge(V,EV)
		@test graph.fadjlist == [[2,4],[1,3],[2,4],[1,3],[6,8],[5,7],[6,8],[5,7]]
	end

	@testset "model2graph_edge2edge" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
		graph = Common.model2graph(V,EV)
		@test graph.fadjlist == [[2,4],[1,3],[2,4],[1,3],[6,8],[5,7],[6,8],[5,7]]
	end

	@testset "makes_direct(g,s)" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]
		EV = [[1,2],[2,6],[6,5],[5,8],[8,7],[7,3],[4,3],[1,4]]
		g = Common.model2graph(V,EV)
		graph = Common.makes_direct(g,1)
		@test graph.fadjlist == [[2],[6],[4],[1],[8],[5],[3],[7]]
	end
end
