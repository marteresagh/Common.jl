@testset "Rotations" begin

	@testset "matrix2euler" begin
		rotation = Lar.r(pi/3, 0, 0)
		euler = Common.matrix2euler(rotation)
		@test euler ≈ [pi/3, 0, 0]

		rotation = Lar.r(0, pi/4, 0)
		euler = Common.matrix2euler(rotation)
		@test euler ≈ [0, pi/4, 0]

		rotation = Lar.r(0, 0, pi/12)
		euler = Common.matrix2euler(rotation)
		@test euler ≈ [0, 0, pi/12]

		rotation = Lar.r(pi/3, 0, 0)*Lar.r(0, pi/4, 0)*Lar.r(0, 0, pi/12)
		euler = Common.matrix2euler(rotation)
		@test euler ≈ [pi/3,pi/4,pi/12]
	end

	@testset "euler2matrix" begin
		euler = [pi/2,pi/5,pi/7]
		rot = Lar.r(pi/2, 0, 0)*Lar.r(0, pi/5, 0)*Lar.r(0, 0, pi/7)
		rotation = Common.euler2matrix(euler...)
		@test Common.matrix4(rotation) ≈ rot
	end

end
