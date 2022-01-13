@testset "extrude" begin
    V = [0 10 10 0 1 9 9 1; 0 0 10 10. 1 1 9 9]
    FV = [[1,2,5],[2,5,6],[2,6,3],[6,3,7],[3,4,7],[4,7,8],[1,4,8],[1,5,8]]
    T,FT = Common.extrude(V, FV, 3.)
    @test size(T,2) == 16
    @test length(FT) == 32

    EV = [[1,2],[2,3],[3,4],[1,4],[5,6],[6,7],[7,8],[8,5]]
    T,ET = Common.extrude(V, EV, 3.)
    @test size(T,2) == 16
    @test length(ET) == 16

end
