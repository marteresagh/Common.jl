@testset "Double vertices" begin

	@testset "remove_double_verts" begin
		dim = 2
		V = [1. 2. 3. 1. 2. 4. 5. 4. 5. 3.;
			1. 1. 3. 2. 2. 4. 4. 5. 5. 3.]
		T,inds = Common.remove_double_verts(V, dim)
		@test T == V[:,1:9]
		@test inds == collect(1:9)

		dim = 2
		[0.504265  0.960838  0.510291  0.12767   0.513024  0.163572  0.321616  0.218421  0.769508    0.510291;
 			0.327851  0.582116  0.965744  0.63266   0.547962  0.779063  0.433883  0.726959  0.0755752   0.965744;
 			0.42326   0.961364  0.848957  0.582004  0.738998  0.169038  0.450948  0.788794  0.335797  0.848957]
		T,inds = Common.remove_double_verts(V, dim)
		@test T == V[:,1:9]
		@test inds == collect(1:9)
	end

end
