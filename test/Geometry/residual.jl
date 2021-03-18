@testset "Residual" begin

	@testset "Dist_Point2Plane" begin
		plane = Hyperplane([1.0,0.0,0.0],[0.0,0.0,0.0])
		@test Common.residual(plane)([2.0,0.0,0.0]) == 2.0
	end

	@testset "Dist_Point2Line" begin
		line = Hyperplane([0.0,1.0],[0.0,0.0])
		@test Common.residual(line)([2.0,0.0]) == 2.0
	end

	@testset "Dist_Point2Sphere" begin
		circle = Hypersphere([0.0,0.0],4.)
		@test Common.residual(circle)([3.0,0.0]) == 1.0
		@test Common.residual(circle)([6.0,0.0]) == 2.0

		circle = Hypersphere([1.0,3.0],4.)
		@test Common.residual(circle)([1.0,0.0]) == 1.0
	end

	@testset "minresidual" begin
		points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
					1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0;
					0.0 5.0 2.0 1.0 2.0 1.0 3.0 7.0 1.0 4.0 ]

		plane = Hyperplane([0.0,0.0,1.0],[0.0,0.0,0.0])
		ind = Common.minresidual(points, plane)
		@test ind == 1

		points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
					1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0]

		line = Hyperplane([0.0,1.0],[0.0,0.0])
		ind = Common.minresidual(points, line)
		@test ind == 1
	end
end
