function execute_benchmark()
    opts =  [463, 289, 4, 288, 258, 30, 203]

    j = 1
    for file in readdir("./data")
        if occursin(".txt", file)
            println("Solving instance: $file")
            instance = scpInstance("./data/" * file)
            times = zeros(10)
            costs = zeros(10)
            diffs = zeros(10)
            for i in 1:10
                Random.seed!(i)
                gene = rand(instance.num_col)
                info = @timed set_cover_decoder(gene, instance)
                times[i] = info[2]
                costs[i] = info[1]
                diffs[i] = (costs[i] - opts[j]) / opts[j]
            end
            println("Mean time: $(mean(times))")
            println("Mean cost: $(mean(costs))")
            println("Mean diff: $(mean(diffs))")
            println("Best cost: $(minimum(costs))")
            j += 1
        end
    end
end