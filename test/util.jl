@testset "Util" begin

	@testset "centroid" begin
		V,CV = Lar.cuboid([1,1])
		@test Common.centroid(V)==[0.5,0.5]

		V,CV = Lar.cuboid([1,1,1])
		@test Common.centroid(V)==[0.5,0.5,0.5]
	end

	@testset "matchcolumn" begin
		a = [1,2,3]
		c = [2,3,7]
		B = [1 4 5; 2 7 8; 3 5 9]
		@test Common.matchcolumn(c,B) == nothing
		@test Common.matchcolumn(a,B) == 1
	end

	@testset "matrix-euler" begin
		angles = [0,pi/4,pi/2]
		M = Common.euler2matrix(angles...)
		euler = Common.matrix2euler(M)
		@test euler ≈ angles
	end

end
