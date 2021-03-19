@testset "Tools" begin

	@testset "Lines" begin
		V = [1. 2. 3. 4.;0. 0. 0. 0.]
		line1 = Hyperplane(PointCloud(V),[1.,0.],[2.5,0.])

		V = [0. 0. 0. 0.;1. 2. 3. 4.]
		line2 = Hyperplane(PointCloud(V),[0.,1.],[0.,2.5])

		lines = [line1,line2]
		V,EV = Common.DrawLines(lines)
		@test size(V,2) == 4
		@test length(EV) == 2

		V,EV = Common.DrawLines(line1)
		@test size(V,2) == 2
		@test length(EV) == 1
		@test V == [1. 4.; 0. 0. ]
	end

	@testset "Planes" begin
		points = [1. 1. 2. 2.;
				1. 2. 1. 2.;
				0.1 0.01 -0.01 0.]
		params = Common.LinearFit(points)
		plane1 = Hyperplane(PointCloud(points),params...)

		points = [1. 1. 2. 2.;
				0.1 0.01 -0.01 0.;
				1. 2. 1. 2.]
		params = Common.LinearFit(points)
		plane2 = Hyperplane(PointCloud(points),params...)

		points = [0.1 0.01 -0.01 0.;
				1. 1. 2. 2.;
				1. 2. 1. 2.]
		params = Common.LinearFit(points)
		plane3 = Hyperplane(PointCloud(points),params...)

		planes = [plane1,plane2,plane3]
		V,EV,FV = Common.DrawPlanes(planes; box_oriented=true)
		@test size(V,2) == 12
		@test length(FV) == 6
		V,EV,FV = Common.DrawPlanes(planes; box_oriented=false)
		@test size(V,2) == 15
		@test length(FV) == 9
	end

	@testset "Patches" begin

	end

end
