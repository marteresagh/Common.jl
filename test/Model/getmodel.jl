@testset "Get Model" begin

	@testset "AABB and Volume" begin
		aabb = AABB(2,0,2,0,2,0)
		obb = Volume([2,2,2],[1,1,1],[0,0,0])
		@test Common.getmodel(aabb) == Common.getmodel(obb)
	end

	@testset "Plane" begin
		plane = Plane(0.,0.,1.,1.)
		thickness = 1.
		aabb = AABB(2,0,2,0,2,0)
		V,EV,FV = Common.getmodel(plane,thickness,aabb)
		@test size(V,2) == 8


		p1 = [0.,0.,0.]
		p2 = [2,.0,.0]
		axis_y = [0.,4.,0.]
		V,EV,FV = Common.getmodel(p1,p2,axis_y,thickness,aabb)

		@test V == [  0.0  0.0   0.0  0.0   2.0  2.0   2.0  2.0;
  					0.0  0.0   2.0  2.0   0.0  0.0   2.0  2.0;
 				 	-0.5  0.5  -0.5  0.5  -0.5  0.5  -0.5  0.5]

	end
end
