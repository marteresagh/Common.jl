@testset "Estimation" begin

	@testset "compute_normals" begin
		k = 9
		#points on plane with normal
		normal = [0.3674, 0.9237, -0.1082]
		V = [ 0.520408  0.130797   0.82929    0.811748  0.672548   0.118836   0.626562   0.10159   0.471247  0.661766;
 			0.117992  0.660728   0.923514   0.88808   0.0907547  0.0498302  0.0566162  0.189819  0.135681  0.888466;
 			2.77447   6.08495   10.7003    10.3382    3.05855    0.828941   2.61095    1.9655    2.75854   9.8322]
		normals = Common.compute_normals(V, Inf, k)
		@test Lar.approxVal(4).(normals) == hcat(fill(normal, 10)...)
	end

end
