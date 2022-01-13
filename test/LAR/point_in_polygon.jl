@testset "point in polygon" begin
    @testset "convex polygon" begin
        V = [3. 10. 13. 10. 3. 0.; 0. 0. 5. 11. 11. 5.]
        EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]

        p = [20.,20.]
        @test Common.pointInPolygonClassification(V,EV)(p)  == "p_out"
        copEV = Common.lar2cop(EV)
        @test !Common.point_in_face(p, permutedims(V), copEV)

        p = [5.,5.]
        @test Common.pointInPolygonClassification(V,EV)(p) == "p_in"
        copEV = Common.lar2cop(EV)
        @test Common.point_in_face(p, permutedims(V), copEV)

        p = [5.,0.]
        @test Common.pointInPolygonClassification(V,EV)(p)  == "p_on"
        copEV = Common.lar2cop(EV)
        @test !Common.point_in_face(p, permutedims(V), copEV)
    end

    @testset "no convex polygon" begin
        V = [3. 10. 4. 10. 3. 0.; 0. 0. 5. 11. 11. 5.]
        EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]

        p = [5.,5.]
        @test Common.pointInPolygonClassification(V,EV)(p)  == "p_out"
        copEV = Common.lar2cop(EV)
        @test !Common.point_in_face(p, permutedims(V), copEV)

        p = [1.,5.]
        @test Common.pointInPolygonClassification(V,EV)(p) == "p_in"
        copEV = Common.lar2cop(EV)
        @test Common.point_in_face(p, permutedims(V), copEV)

        p = [5.,0.]
        @test Common.pointInPolygonClassification(V,EV)(p)  == "p_on"
        copEV = Common.lar2cop(EV)
        @test !Common.point_in_face(p, permutedims(V), copEV)
    end


end
