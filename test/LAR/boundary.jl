@testset "Boundary" begin

	@testset "get_boundary_points" begin
		V = [1. 5. 2. 3. 6. 4. 8. 7.;
			0. 0. 0. 0. 0. 0. 0. 0.]

		EV = [[1,3],[3,4],[4,6],[6,2],[2,5],[5,8],[8,7]]
		VV = Common.get_boundary_points(V,EV)
		@test sort(VV) == [1,7]
	end

	@testset "get_boundary_edges" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]

		FV = [[1, 2, 5],[1, 4, 5],[2, 3, 6],[2, 5, 6],[3, 4, 8],[3, 6, 7],
			[3, 7, 8],[4, 5, 8],[5, 6, 7],[5, 7, 8]]
		EV = Common.get_boundary_edges(V,FV)
		@test sort(sort.(EV)) == [[1,2],[1,4],[2,3],[3,4]]
	end

	@testset "get_boundary_faces" begin
		V = [ 0.0  0.0  0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0  1.0  1.0;
			  0.0  0.0  1.0  1.0  2.0  2.0  0.0  0.0  1.0  1.0  2.0  2.0;
		 	  0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0
			]
		CV = [[1, 2, 3, 4, 7, 8, 9, 10], [3, 4, 5, 6, 9, 10, 11, 12]]
		FV = Common.get_boundary_faces(V,CV)
		@test sort(sort.(FV)) == [[1, 2, 3, 4],[1, 2, 7, 8],[1, 3, 7, 9],[2, 4, 8, 10],[3, 4, 5, 6],
		[3, 5, 9, 11],[4, 6, 10, 12],[5, 6, 11, 12],[7, 8, 9, 10],[9, 10, 11, 12]]
	end


end
