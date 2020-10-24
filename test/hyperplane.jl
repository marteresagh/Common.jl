@testset "Hyperplane" begin

	@testset "residual" begin
		line = Hyperplane([0.0,1.0],[0.0,0.0])
		@test Common.residual(line)([2.0,0.0]) == 2.0
		plane = Hyperplane([1.0,0.0,0.0],[0.0,0.0,0.0])
		@test Common.residual(plane)([2.0,0.0,0.0]) == 2.0

	end

	@testset "2D" begin
		points = [  1.20728  2.37415  1.58554  1.94907  0.423596  0.364242  2.68154  2.78471  2.4795  2.77911
				 	2.20728  3.37415  2.58554  2.94907  1.4236    1.36424   3.68154  3.78471  3.4795  3.77911]
		params2D = Common.LinearFit(points)
		@test params2D[1] ≈ [-0.7071069057607821, -0.707106656612291]

		@test isapprox.(Common.residual(Hyperplane(params2D...)).([points[:,i] for i in 1:10]), zeros(10),atol=4)==ones(10)
	end

	@testset "3D" begin

		points = [  2.94039  0.516412   2.29075  0.15646  0.180136   2.39555  0.390856   2.64535  0.804749   2.82538
					3.80147  1.99903    1.5376   3.26004  0.162415   1.42049  1.54317    1.97008  2.95325    1.07629
				 	17.4241   6.5473    10.9475   7.98946  1.86524   11.0276   5.2589    12.8762   9.32074   11.6287]
		params3D = Common.LinearFit(points)
		@test params3D[1] ≈ [0.8017835998182375, 0.5345225852806715, -0.2672614167577797]

		@test isapprox.(Common.residual(Hyperplane(params3D...)).([points[:,i] for i in 1:10]), zeros(10),atol=4)==ones(10)
	end

end
