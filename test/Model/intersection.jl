@testset "Model Intersection" begin

	@testset "box_intersects_plane" begin
		normal = [0.,0.,1.]
		centroid = [0.,0.,0.]
		box = AABB(2.,-2.,2.,-2.,2.,-2.)
		V = Common.box_intersects_plane(box, normal, centroid)
		@test size(V,2) == 4

		box = Volume([4.,4.,4.],[0.,0.,-2.],[pi/4,pi/4,0.])
		V = Common.box_intersects_plane(box, normal, centroid)
		@test size(V,2) == 3
	end

	@testset "AABBdetection" begin
		#3D
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

		#2D
		A = AABB(1.,0.,1.,0.,0.,0.)

		B = AABB(1.5,0.5,1.5,0.5,0.,0.)
		@test Common.AABBdetection(A,B)

		B = AABB(1.,0.,1.,0.,0.,0.)
		@test Common.AABBdetection(A,B)

		B = AABB(0.6,0.2,0.6,0.2,0.,0.)
		@test Common.AABBdetection(A,B)

		B = AABB(2.,1.,2.,1.,0.,0.)
		@test !Common.AABBdetection(A,B)

		B = AABB(2.5,1.5,2.5,1.5,0.,0.)
		@test !Common.AABBdetection(A,B)
	end

	@testset "inmodel" begin
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

		@testset "OBB and AABB" begin
			volume = Volume([1.,1.,1.],[0.,0.,0.],[0,0,pi/4])
			model = Common.getmodel(volume)

			octree = AABB(1.5,0.7,1.5,0.7,1.5,0.7)
			@test Common.modelsdetection(model,octree) == 0

			octree = AABB(1.5,0.2,1.5,0.2,1.5,0.2)
			@test Common.modelsdetection(model,octree) == 1

			octree = AABB(0.1,-0.1,0.1,-0.1,0.1,-0.1)
			@test Common.modelsdetection(model,octree) == 2

			volume = Volume([2*sqrt(2),2*sqrt(2),2*sqrt(2)],[0.,0.,0.],[0,0,pi/4])
			octree = AABB(1.9,0.6,1.9,0.6,1.,0.)
			@test Common.modelsdetection(model,octree) == 0
		end
	end

end
