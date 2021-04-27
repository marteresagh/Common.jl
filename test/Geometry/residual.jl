@testset "Residual" begin

	@testset "distance_point2plane" begin
		centroid = [0.0,0.0,0.0]
		direction = [1.0,0.0,0.0]
		plane = Common.Plane(direction,centroid)
		@test Common.residual(plane)([2.0,0.0,0.0]) == 2.0
	end

	@testset "Dist_Point2Line" begin
		centroid = [0.0,0.0]
		direction = [0.0,1.0]
		line = Common.Line(centroid,direction,1)
		@test Common.residual(line)([2.0,0.0]) == 2.0
	end

	# @testset "Dist_Point2Sphere" begin
	# 	circle = Common.Hypersphere([0.0,0.0],4.)
	# 	@test Common.residual(circle)([3.0,0.0]) == 1.0
	# 	@test Common.residual(circle)([6.0,0.0]) == 2.0
	#
	# 	circle = Common.Hypersphere([1.0,3.0],4.)
	# 	@test Common.residual(circle)([1.0,0.0]) == 1.0
	# end
	#
	# @testset "minresidual" begin
	# 	points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
	# 				1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0;
	# 				0.0 5.0 2.0 1.0 2.0 1.0 3.0 7.0 1.0 4.0 ]
	#
	# 	plane = Common.Hyperplane([0.0,0.0,1.0],[0.0,0.0,0.0])
	# 	ind = Common.minresidual(points, plane)
	# 	@test ind == 1
	#
	# 	points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
	# 				1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0]
	#
	# 	line = Common.Hyperplane([0.0,1.0],[0.0,0.0])
	# 	ind = Common.minresidual(points, line)
	# 	@test ind == 1
	# end
end
