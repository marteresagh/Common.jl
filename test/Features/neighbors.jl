@testset "NearestNeighbors" begin

    points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0
                0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
                0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ]

    kdtree = NearestNeighbors.KDTree(points)
    seeds = [1,2]
    visitedverts = [1,2,3]
    threshold = 5.0
    k = 5
    NN = Common.neighborhood(kdtree, points, seeds, visitedverts, threshold, k)
    @test NN == [4,5,6,7]

end
