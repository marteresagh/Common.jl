
@testset "Model Intersection" begin

	@testset "AABB detection" begin
		A = AABB(1.,0.,1.,0.,1.,0.)

		B = AABB(1.5,0.5,1.5,0.5,1.5,0.5)
		@test Common.AABBdetection(A,B)

		B = AABB(1.,0.,1.,0.,1.,0.)
		@test Common.AABBdetection(A,B)

		B = AABB(0.6,0.2,0.6,0.2,0.6,0.2)
		@test Common.AABBdetection(A,B)

		B = AABB(2.,1.,2.,1.,2.,1.)
		@test !Common.AABBdetection(A,B)

		B = AABB(2.5,1.5,2.5,1.5,2.5,1.5,)
		@test !Common.AABBdetection(A,B)
	end

	@testset "In model" begin
		A = AABB(1.,0.,1.,0.,1.,0.)
		model = Common.getmodel(A)

		@test Common.inmodel(model)([0.5,0.5,0.5])
		@test !Common.inmodel(model)([1.5,0.5,0.5])
	end

	@testset "Detection" begin
		@testset "Two AABB" begin
			A = AABB(1.,0.,1.,0.,1.,0.)
			model = Common.getmodel(A)

			octree = AABB(4.,2.,4.,2.,4.,2.)
			@test Common.modelsdetection(model,octree) == 0

			octree = AABB(4.,0.5,4.,0.5,4.,0.5)
			@test Common.modelsdetection(model,octree) == 1

			octree = AABB(0.7,0.2,0.7,0.2,0.7,0.2)
			@test Common.modelsdetection(model,octree) == 2
		end

		@testset "Rotated box and AABB" begin
			volume = Volume([1.,1.,1.],[0.,0.,0.],[0,0,pi/4])
			model = Common.volume2LARmodel(volume)

			octree = AABB(1.5,0.7,1.5,0.7,1.5,0.7)
			@test Common.modelsdetection(model,octree) == 0

			octree = AABB(1.5,0.2,1.5,0.2,1.5,0.2)
			@test Common.modelsdetection(model,octree) == 1

			octree = AABB(0.1,-0.1,0.1,-0.1,0.1,-0.1)
			@test Common.modelsdetection(model,octree) == 2
		end

	end
end
