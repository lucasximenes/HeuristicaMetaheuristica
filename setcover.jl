using Random, Statistics, BrkgaMpIpr

include("Data/scpInstance.jl")
include("utils.jl")
include("Algorithms/construtivos.jl")
include("Algorithms/decoders.jl")
include("LocalSearch/oneflip.jl")
include("LocalSearch/twoflip.jl")
include("benchmark.jl")

function main()

    instance = scpInstance("./Data/instances/scp41.txt")

    sol = outroConst(instance)

    @show sol.cost, sol.x

    oneFlip = OneFlip(instance, sol)
    bestImprovement!(oneFlip)
    @show oneFlip.solution.cost, oneFlip.solution.x

    twoFlip = TwoFlip(instance, sol)
    bestImprovement!(twoFlip)
    @show twoFlip.solution.cost, twoFlip.solution.x

    random_chromosome = rand(instance.num_col)
    
    rand_sol = set_cover_decoder(random_chromosome, instance, false, true)

    @show rand_sol.cost, rand_sol.x

    oneFlip = OneFlip(instance, rand_sol)
    bestImprovement!(oneFlip)
    @show oneFlip.solution.cost, oneFlip.solution.x
    
    # twoFlip = TwoFlip(instance, rand_sol)
    # bestImprovement!(twoFlip)
    # @show twoFlip.solution.cost, twoFlip.solution.x

    # initial_chromosome = buildChromosome(instance, sol)

    # if (set_cover_decoder(initial_chromosome, instance, false) == sol.cost)
    #     @info "Decoder and initial solution are OK"
    # else
    #     @error "Decoder and/or initial solution are NOT OK"
    # end

    # brkga_data, control_params = build_brkga(instance, set_cover_decoder, MINIMIZE, 4, instance.num_col, "config.conf")

    # set_initial_population!(brkga_data, [initial_chromosome])
    # initialize!(brkga_data)

    # @time evolve!(brkga_data, 15)

    # best_cost = get_best_fitness(brkga_data)
    # @show best_cost
    return
end

execute_benchmark()