@testset "Boundary" begin

	@testset "get_boundary_edges" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]

		FV = [[1, 2, 5],[1, 4, 5],[2, 3, 6],[2, 5, 6],[3, 4, 8],[3, 6, 7],
			[3, 7, 8],[4, 5, 8],[5, 6, 7],[5, 7, 8]] 
		EV = Common.get_boundary_edges(V,FV)
		@test sort(sort.(EV)) == [[1,2],[1,4],[2,3],[3,4]]
	end

end
