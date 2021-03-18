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

	@testset "orthonormal basis" begin
		versore = [-0.8118179363447104, -0.6121680290248144, 0.6306343699009158]
		M = Common.orthonormal_basis(versore...)
		@test isapprox(Lar.det(M),1)
	end

end
