@testset "Delaunay" begin

	@testset "2D" begin
		@testset "one tetrahedron" begin
			P = [
				0.0 1.0 0.0
				0.0 0.0 1.0
			];
			DT = Common.delaunay_triangulation(P)
			@test DT == [ [1, 2, 3] ]
		end

		@testset "two tetrahedron" begin
			P = [
				0.0 1.0 0.0 2.0
				0.0 0.0 1.0 0.0
			];
			DT = Common.delaunay_triangulation(P)
			@test DT == [ [1, 2, 3], [2, 3, 4] ]
		end

		@testset "cube" begin
			P = [
				0.0 1.0 0.0 1.0
				0.0 0.0 1.0 1.0
			];
			DT = Common.delaunay_triangulation(P)
			@test length(DT) == 2
		end
	end

	@testset "3D" begin
		@testset "one tetrahedron" begin
			P = [
				0.0 1.0 0.0 0.0
				0.0 0.0 1.0 0.0
				0.0 0.0 0.0 1.0
			];
			DT = Common.delaunay_triangulation(P)
			@test DT == [ [1, 2, 3, 4] ]
		end

		@testset "two tetrahedron" begin
			P = [
				0.0 1.0 0.0 0.0 2.0
				0.0 0.0 1.0 0.0 0.0
				0.0 0.0 0.0 1.0 0.0
			];
			DT = Common.delaunay_triangulation(P)
			@test DT == [ [1, 2, 3, 4], [2, 3, 4, 5] ]
		end

		@testset "cube" begin
			P = [
				0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0
				0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0
				0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0
			];
			DT = Common.delaunay_triangulation(P)
			@test length(DT) == 6
		end
	end

	# @testset "constrained Delaunay"	begin
	# 	V = [0. 4. 4. 0. 2. 3. 3. 2;
	# 		0. 0. 4. 4. 2. 2. 3. 3.]
	# 	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
	# 	trias = Lar.triangulate2d(V, EV)
	#
	# 	@test sort(sort.(trias)) == [ [1, 2, 5],[1, 4, 5],[2, 3, 6],[2, 5, 6],[3, 4, 8],[3, 6, 7],[3, 7, 8],[4, 5, 8]]
	# end

end
