
@testset "Model Intersection" begin

	@testset "AABB detection" begin
		A = AABB(1.,0.,1.,0.,1.,0.)

		B = AABB(1.5,0.5,1.5,0.5,1.5,0.5)
		@test AABBdetection(A,B)

		B = AABB(1.,0.,1.,0.,1.,0.)
		@test AABBdetection(A,B)

		B = AABB(0.6,0.2,0.6,0.2,0.6,0.2)
		@test AABBdetection(A,B)

		B = AABB(2.,1.,2.,1.,2.,1.)
		@test !AABBdetection(A,B)

		B = AABB(2.5,1.5,2.5,1.5,2.5,1.5,)
		@test !AABBdetection(A,B)

	end

end
