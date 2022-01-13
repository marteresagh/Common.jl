@testset "point in polyhedron" begin
    @testset "convex solid" begin
        aabb = AABB(2,0,2,0,2,0)
		V,EV,FV = Common.getmodel(aabb)

		point = [1,1,1.]
        face_intersected = Common.testinternalpoint(V, EV, FV)(point)
		@test length(face_intersected)%2 == 1
		@test !Common.point_in_polyhedron(point, V, EV, FV)

		point = [10,10,10.]
        face_intersected = Common.testinternalpoint(V, EV, FV)(point)
		@test length(face_intersected)%2 == 0
		@test Common.point_in_polyhedron(point, V, EV, FV)

		point = [1,1,-2.]
		face_intersected = Common.testinternalpoint(V, EV, FV)(point)
		@test length(face_intersected)%2 == 0
		@test Common.point_in_polyhedron(point, V, EV, FV)

		point = [2,1,1.]
		face_intersected = Common.testinternalpoint(V, EV, FV)(point)
		@test length(face_intersected)%2 == 1
		@test !Common.point_in_polyhedron(point, V, EV, FV)
	end

end
