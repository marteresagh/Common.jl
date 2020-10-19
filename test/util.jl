@testset "Util" begin

	@testset "centroid" begin
		V,CV = Lar.cuboid([1,1])
		@test centroid(V)==hcat([0.5;0.5])

		V,CV = Lar.cuboid([1,1,1])
		@test centroid(V)==hcat([0.5;0.5;0.5])
	end

	@testset "matchcolumn" begin
		a = [1,2,3]
		c = [2,3,7]
		B = [1 4 5; 2 7 8; 3 5 9]
		@test matchcolumn(a,B) == 1
		@test matchcolumn(c,B) == nothing
	end

end
