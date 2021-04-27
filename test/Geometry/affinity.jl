@testset "orthonormal basis" begin
	vect = [sqrt(2)/2,-sqrt(2)/2,0]
	M = Common.orthonormal_basis(vect...)
	@test isapprox(Common.det(M),1)
	@test M[:,3] == vect

	vect = [1.,0.,0.]
	M = Common.orthonormal_basis(vect...)
	@test isapprox(Common.det(M),1)
	@test M[:,3] == vect

	vect = [0.,1.,0.]
	M = Common.orthonormal_basis(vect...)
	@test isapprox(Common.det(M),1)
	@test M[:,3] == vect

	vect = [0.,0.,1.]
	M = Common.orthonormal_basis(vect...)
	@test isapprox(Common.det(M),1)
	@test M[:,3] == vect

	p1 = [0.,0.,0.]
	p2 = [2,.0,.0]
	axis_y = [0.,4.,0.]
	M = Common.orthonormal_basis(p1,p2,axis_y)
	@test M == Matrix(Common.I,3,3)

	p1 = [0.,0.,0.]
	p2 = [-1.,2.,0.]
	axis_y = [0.,-1.,0.]
	M = Common.orthonormal_basis(p1,p2,axis_y)
	@test isapprox(Common.det(M),1)

end

@testset "matrix2euler" begin
	rotation = Common.r(pi/3, 0, 0)
	euler = Common.matrix2euler(rotation)
	@test euler ≈ [pi/3, 0, 0]

	rotation = Common.r(0, pi/2, 0)
	euler = Common.matrix2euler(rotation)
	@test euler ≈ [0, pi/2, 0]

	rotation = Common.r(0, 0, pi/12)
	euler = Common.matrix2euler(rotation)
	@test euler ≈ [0, 0, pi/12]

	rotation = Common.r(pi/3, 0, 0)*Common.r(0, pi/4, 0)*Common.r(0, 0, pi/12)
	euler = Common.matrix2euler(rotation)
	@test euler ≈ [pi/3,pi/4,pi/12]
end

@testset "euler2matrix" begin
	euler = [pi/2,pi/5,pi/7]
	rot = Common.r(pi/2, 0, 0)*Common.r(0, pi/5, 0)*Common.r(0, 0, pi/7)
	rotation = Common.euler2matrix(euler...)
	@test Common.matrix4(rotation) ≈ rot
end



@testset "apply affine matrix" begin

	@testset "2D" begin
		square = [[0.; 0] [0; 1] [1; 0] [1; 1]]
		@testset "apply Translation 2D" begin
			@test Common.apply_matrix(Common.t(-0.5,-0.5),square)==[-0.5 -0.5 0.5 0.5; -0.5 0.5 -0.5 0.5]
		end
		@testset "apply Scaling 2D" begin
			@test Common.apply_matrix(Common.s(-0.5,-0.5),square)==[0.0 0.0 -0.5 -0.5; 0.0 -0.5 0.0 -0.5]
		end
		@testset "apply Rotation 2D" begin
			@test Common.apply_matrix(Common.r(0),square)==[0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0]
		end
	end

	@testset "3D" begin
		cube = [0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0;
		0.0  0.0  1.0  1.0  0.0  0.0  1.0  1.0;
		0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0]
		@testset "apply Translation 3D" begin
			@test Common.apply_matrix(Common.t(-0.5, -0.5, -0.5),cube) ==
			[-0.5 -0.5 -0.5 -0.5 0.5 0.5 0.5 0.5;
			-0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5;
			-0.5 0.5 -0.5 0.5 -0.5 0.5 -0.5 0.5]
		end
		@testset "apply Scaling 3D" begin
			@test Common.apply_matrix(Common.s(-0.5, -0.5, -0.5),cube) ==
			[0.0 0.0 0.0 0.0 -0.5 -0.5 -0.5 -0.5;
			0.0 0.0 -0.5 -0.5 0.0 0.0 -0.5 -0.5;
			0.0 -0.5 0.0 -0.5 0.0 -0.5 0.0 -0.5]
		end
		@testset "apply Rotation 3D" begin
			@test Common.apply_matrix(Common.r(0, 0, 0),cube) ==
			[0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0;
			0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0;
			0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0]

			@test Common.apply_matrix(Common.r(0, 0, pi),cube) ≈
			[0.0 0.0 0.0 0.0 -1.0 -1.0 -1.0 -1.0;
			0.0 0.0 -1.0 -1.0 0.0 0.0 -1.0 -1.0;
			0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0]
		end
	end
end
