@testset "interface" begin
	@testset "cop2lar lar2cop" begin
		EV = [
		        [1, 2],
		        [2, 3],
		        [3, 4],
		        [4, 5],
		        [3, 6],
		        [1, 6],
		        [6, 7],
		        [7, 9],
		        [8, 9],
		        [8, 10],
		        [9, 10],
		]

		copEV = Common.lar2cop(EV)
		cop2EV = Common.cop2lar(copEV)
		@test cop2EV == EV
		@test sum(copEV,dims=2)[:,1] == 2*ones(Int,length(EV))


		FV = [
		    [1, 2, 3, 4],
		    [5, 6, 7, 8],
		    [1, 2, 5, 6],
		    [3, 4, 7, 8],
		    [1, 3, 5, 7],
		    [2, 4, 6, 8],
		    [9, 10, 11, 12],
		    [13, 14, 15, 16],
		    [9, 10, 13, 14],
		    [11, 12, 15, 16],
		    [9, 11, 13, 15],
		    [10, 12, 14, 16],
		]

		copFV = Common.lar2cop(FV)
		cop2FV = Common.cop2lar(copFV)
		@test cop2FV == FV
		@test sum(copFV,dims=2)[:,1] == 4*ones(Int,length(FV))



		FV = [
		    [1, 2, 3],
		    [1, 2, 4],
		    [2, 4, 5],
		]

		copFV = Common.lar2cop(FV)
		cop2FV = Common.cop2lar(copFV)
		@test cop2FV == FV
		@test sum(copFV,dims=2)[:,1] == 3*ones(Int,length(FV))
	end

	@testset "cobordo" begin

	end
	
end
