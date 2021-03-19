@testset "Util" begin

	@testset "angle_between_directions" begin
		a = [1.,0.]
		b = [0.,1.]
 		@test Common.angle_between_directions(a,b) == pi/2

		b = [-sqrt(2)/2,sqrt(2)/2]
		@test Common.angle_between_directions(a,b) == pi/4

		b = [-1.,0.]
		@test Common.angle_between_directions(a,b) == 0

		a = [1.,0.,0.]
		b = [0.,1.,0.]
		@test Common.angle_between_directions(a,b) == pi/2

		b = [-sqrt(2)/2,sqrt(2)/2,0.]
		@test Common.angle_between_directions(a,b) == pi/4

		b = [-1.,0.,0.]
		@test Common.angle_between_directions(a,b) == 0
	end


	@testset "apply_matrix" begin
		V = [0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
			1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0]
		T = Common.apply_matrix(Lar.t(1,0), V)
		@test T == V.+[1,0]

		T = Common.apply_matrix(Lar.t(1,0), V[:,4])
		@test T == reshape(V[:,4]+[1,0],2,1)
	end


	@testset "centroid" begin
		V,CV = Lar.cuboid([1,1])
		@test Common.centroid(V)==[0.5,0.5]

		V,CV = Lar.cuboid([1,1,1])
		@test Common.centroid(V)==[0.5,0.5,0.5]
	end

	@testset "matchcolumn" begin
		a = [1,2,3]
		c = [2,3,7]
		B = [1 4 5; 2 7 8; 3 5 9]
		@test Common.matchcolumn(c,B) == nothing
		@test Common.matchcolumn(a,B) == 1
	end

	@testset "orthonormal basis" begin
		vect = [sqrt(2)/2,-sqrt(2)/2,0]
		M = Common.orthonormal_basis(vect...)
		@test isapprox(Lar.det(M),1)
		@test M[:,3] == vect

		vect = [1.,0.,0.]
		M = Common.orthonormal_basis(vect...)
		@test isapprox(Lar.det(M),1)
		@test M[:,3] == vect

		vect = [0.,1.,0.]
		M = Common.orthonormal_basis(vect...)
		@test isapprox(Lar.det(M),1)
		@test M[:,3] == vect

		vect = [0.,0.,1.]
		M = Common.orthonormal_basis(vect...)
		@test isapprox(Lar.det(M),1)
		@test M[:,3] == vect

		p1 = [0.,0.,0.]
		p2 = [2,.0,.0]
		axis_y = [0.,4.,0.]
		M = Common.orthonormal_basis(p1,p2,axis_y)
		@test M == Matrix(Lar.I,3,3)

		p1 = [0.,0.,0.]
		p2 = [-1.,2.,0.]
		axis_y = [0.,-1.,0.]
		M = Common.orthonormal_basis(p1,p2,axis_y)
		@test isapprox(Lar.det(M),1)

	end

end
