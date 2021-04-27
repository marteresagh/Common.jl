@testset "Tools" begin

	# @testset "Lines" begin
	# 	V = [1. 2. 3. 4.;0. 0. 0. 0.]
	# 	line1 = Hyperplane(PointCloud(V),[1.,0.],[2.5,0.])
	#
	# 	V = [0. 0. 0. 0.;1. 2. 3. 4.]
	# 	line2 = Hyperplane(PointCloud(V),[0.,1.],[0.,2.5])
	#
	# 	lines = [line1,line2]
	# 	V,EV = Common.DrawLines(lines)
	# 	@test size(V,2) == 4
	# 	@test length(EV) == 2
	#
	# 	V,EV = Common.DrawLines(line1)
	# 	@test size(V,2) == 2
	# 	@test length(EV) == 1
	# 	@test V == [1. 4.; 0. 0. ]
	# end

	# @testset "Planes" begin
		# @testset "hyperplanes" begin
		# 	points = [1. 1. 2. 2.;
		# 			1. 2. 1. 2.;
		# 			0.1 0.01 -0.01 0.]
		# 	params = Common.LinearFit(points)
		# 	plane1 = Hyperplane(PointCloud(points),params...)
		#
		# 	points = [1. 1. 2. 2.;
		# 			0.1 0.01 -0.01 0.;
		# 			1. 2. 1. 2.]
		# 	params = Common.LinearFit(points)
		# 	plane2 = Hyperplane(PointCloud(points),params...)
		#
		# 	points = [0.1 0.01 -0.01 0.;
		# 			1. 1. 2. 2.;
		# 			1. 2. 1. 2.]
		# 	params = Common.LinearFit(points)
		# 	plane3 = Hyperplane(PointCloud(points),params...)
		#
		# 	planes = [plane1,plane2,plane3]
		# 	V,EV,FV = Common.DrawPlanes(planes; box_oriented=true)
		# 	@test size(V,2) == 12
		# 	@test length(FV) == 6
		#
		# 	V,EV,FV = Common.DrawPlanes(planes; box_oriented=false)
		# 	@test size(V,2) == 15
		# 	@test length(FV) == 9
		#
		# 	points = [0.22101   0.227941  0.577049  0.0305353  0.696326  0.669594  0.78308   0.293208  0.216731  0.114549;
	 	# 			0.743021  0.662485  0.749831  0.569599   0.983362  0.595117  0.427165  0.51504   0.116016  0.699694;
		# 			0.01 0.1 -0.01 0.02 0.001 -0.02 -0.01 0.0 -0.01 0.1 ]
		# 	params = Common.LinearFit(points)
		# 	plane = Hyperplane(PointCloud(points),params...)
		# 	V,EV,FV = Common.DrawPlanes(plane; box_oriented=true)
		# 	@test size(V,2) == 4
		# 	@test length(FV) == 2
		# end

	# end

	@testset "Lines" begin
		V = [1. 2. 3. 4.;0. 0. 0. 0.]
		line1 = Line(V)

		V = [0. 0. 0. 0.;1. 2. 3. 4.]
		line2 = Line(V)

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
		plane = Plane(0.,0.,1.,0.)
		aabb = AABB(2.,0.,2.,0.,2.,0.)
		V,EV,FV = Common.DrawPlanes(plane, aabb)
		@test size(V,2) == 4
	end

	@testset "Patches" begin
		plane = Plane(0.,0.,1.,0.)
		aabb = AABB(2.,0.,2.,0.,2.,0.)
		V,EV,FV = Common.DrawPatches([plane], [aabb])
		@test size(V,2) == 4
	end

end
