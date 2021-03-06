@testset "Fit" begin

	@testset "Fit_Line" begin
		points = [1. 2. 3. 4.;
		 		0. 0. 0. 0.]

		params = Common.LinearFit(points)
		@test params[1] ≈ [1.,0.]
		@test params[2] ≈ [2.5, 0.]


		points = [  1.20728  2.37415  1.58554  1.94907  0.423596  0.364242  2.68154  2.78471  2.4795  2.77911;
					2.20728  3.37415  2.58554  2.94907  1.4236    1.36424   3.68154  3.78471  3.4795  3.77911]
		params2D = Common.LinearFit(points)
		@test params2D[1] ≈ [-0.7071069057607821, -0.707106656612291]
	end

	@testset "Fit_Plane" begin
		points = [1. 1. 2. 2.;
		 		1. 2. 1. 2.;
				0. 0. 0. 0.]

		params = Common.LinearFit(points)
		@test params[1] ≈ [0.,0.,1.]
		@test params[2] ≈ [1.5,1.5,0.]

		points = [1. 1. 2. 2.;
				0. 0. 0. 0.;
				1. 2. 1. 2.]

		params = Common.LinearFit(points)
		@test params[1] ≈ [0.,1.,0.]
		@test params[2] ≈ [1.5,0.,1.5]

		points = [0. 0. 0. 0.;
				1. 1. 2. 2.;
				1. 2. 1. 2.]

		params = Common.LinearFit(points)
		@test params[1] ≈ [1.,0.,0.]
		@test params[2] ≈ [0.,1.5,1.5]


		points = [  2.94039  0.516412   2.29075  0.15646  0.180136   2.39555  0.390856   2.64535  0.804749   2.82538;
					3.80147  1.99903    1.5376   3.26004  0.162415   1.42049  1.54317    1.97008  2.95325    1.07629;
				 	17.4241   6.5473    10.9475   7.98946  1.86524   11.0276   5.2589    12.8762   9.32074   11.6287]
		params = Common.PCA(points)
		@test Common.approxVal(4).(params[2][:,3]) ≈ Common.approxVal(4).([0.8017835998182375, 0.5345225852806715, -0.2672614167577797])
		@test Common.approxVal(4).(params[1]) ≈ Common.approxVal(4).([1.5146032999999999, 1.9723835, 9.488574])
	end

	@testset "Fit_Circle" begin
		points = [ 5.05603   5.5785    3.18581  5.97245   1.04468   0.557196  0.224191   3.31071    1.30733   0.303726;
					-0.184657  0.466595  4.99424  2.40567  -0.275239  0.258532  0.86207   -0.983866  -0.476869  3.31534 ]

		C, R = Common.Fit_Circle(points)
		@test isapprox(C,[3.,2.]; atol = 1.e2)
		@test isapprox(R,3.; atol = 1.e2)
	end

end
