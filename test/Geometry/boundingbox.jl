@testset "BoundingBox" begin

	@testset "boundingbox" begin
		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.]
		aabb = Common.boundingbox(V)
		@test aabb.x_max == 5.
		@test aabb.x_min == 1.
		@test aabb.y_max == 5.
		@test aabb.y_min == 1.
		@test aabb.z_max == 0.
		@test aabb.z_min == 0.


		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.;
			1. 1. 1. 1. 5. 5. 5. 5.]
		aabb = Common.boundingbox(V)
		@test aabb.x_max == 5.
		@test aabb.x_min == 1.
		@test aabb.y_max == 5.
		@test aabb.y_min == 1.
		@test aabb.z_max == 5.
		@test aabb.z_min == 1.
	end

	@testset "update_boundingbox!" begin
		aabb = AABB(-Inf, Inf, -Inf, Inf, -Inf, Inf)
		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.;
			1. 1. 1. 1. 5. 5. 5. 5.]

		for i in 1:size(V,2)
			Common.update_boundingbox!(aabb,V[:,i])
		end

		@test aabb.x_max == 5.
		@test aabb.x_min == 1.
		@test aabb.y_max == 5.
		@test aabb.y_min == 1.
		@test aabb.z_max == 5.
		@test aabb.z_min == 1.
	end

	@testset "isinbox" begin
		V = [1. 2. 1. 2. 4. 5. 4. 5.;
			1. 1. 2. 2. 4. 4. 5. 5.;
			1. 1. 1. 1. 5. 5. 5. 5.]
		aabb = Common.boundingbox(V)
		for i in 1:size(V,2)
			@test Common.isinbox(aabb,V[:,i])
		end
	end

	@testset "oriented_boundingbox" begin
		V = [1. 2. 1. 2. 1. 2. 1. 2.;
			1. 1. 2. 2. 1. 1. 2. 2.;
			1. 1. 1. 1. 5. 5. 5. 5.]

		obb = Common.ch_oriented_boundingbox(V)
		@test obb.scale == [4.096024004965141, 1.5112539678134782, 1.0]
		@test obb.position == [1.5, 1.5, 3.0]
		@test obb.rotation ==  [1.5707963267948966, 0.0, 1.4404951309212262]

		obb2 = Common.oriented_boundingbox(V)
		@test obb2.scale == [4.0, 1.0, 1.0]
		@test obb2.position == [1.5, 1.5, 3.0]
		@test obb2.rotation == [0.0, -1.5707963267948966, 0.0]

		# TODO da rivedere ch_oriented il volume non è proprio quello minimo che mi aspetto
		#vol1 = prod(obb.scale)
		#vol2 = prod(obb2.scale)
	end
end
