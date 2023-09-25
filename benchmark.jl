function execute_benchmark(func::Function, constr::Symbol, neighborhood::Union{Type{OneFlip}, Type{TwoFlip}})
    for file in readdir("./Data/instances")
        if occursin(".txt", file)
            println("Solving instance: $file")
            instance = scpInstance("./Data/instances/" * file)
            info = @timed func(instance, constr, neighborhood)
            time = info[2]
            cost = info[1].cost
            println("Time: $time")
            println("Cost: $cost")
        end
    end
end

function execute_benchmark_random()
    opts =  [429,512,253,302,138,146,253,252,69,76,227,219,60,66]

    j = 1
    for file in readdir("./Data/instances")
        if occursin(".txt", file)
            println("Solving instance: $file")
            instance = scpInstance("./Data/instances/" * file)
            times = zeros(10)
            costs = zeros(10)
            diffs = zeros(10)
            for i in 1:10
                Random.seed!(i)
                gene = rand(instance.num_col)
                info = @timed set_cover_decoder_LS(gene, instance, OneFlip)
                times[i] = info[2]
                costs[i] = info[1].cost
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