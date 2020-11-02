using Common

inputBuffer,t = monitorInput()
output = Int64[]
for i in 1:100
    if isready(inputBuffer) && take!(inputBuffer) == 'q'
        break
    end
    push!(output,i)
    print('\r', i)
    sleep(0.1)
end

@show output
println("\nPlease have a nice day!")
Base.throwto(t, InterruptException())
