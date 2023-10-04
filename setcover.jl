using Random, Statistics, BrkgaMpIpr

include("Data/scpInstance.jl")
include("utils.jl")
include("LocalSearch/oneflip.jl")
include("LocalSearch/twoflip.jl")
include("Algorithms/construtivos.jl")
include("Algorithms/decoders.jl")
include("benchmark.jl")

function constAndLS(instance::scpInstance, constr::Symbol, neighborhood::Union{Type{OneFlip}, Type{TwoFlip}})::Solution
    sol = nothing
    if constr == :const
        sol = constByCost(instance)
    elseif constr == :greedy
        sol = outroConst(instance)
    else
        @error "Invalid construction heuristic"
    end

    neighbor = neighborhood(instance, sol)
    bestImprovement!(neighbor)
    return neighbor.solution
end

function main()

    instance = scpInstance("./Data/instances/scp41.txt")

    sol = outroConst(instance)

    oneFlip = OneFlip(instance, sol)
    bestImprovement!(oneFlip)

    @show oneFlip.solution

    # twoFlip = TwoFlip(instance, sol)
    # bestImprovement!(twoFlip)

    # @show twoFlip.solution

    initial_chromosome = buildChromosome(instance, oneFlip.solution)

    println(set_cover_decoder(initial_chromosome, instance, false))
    println(oneFlip.solution.cost)

    if (set_cover_decoder(initial_chromosome, instance, false) == oneFlip.solution.cost)
        @info "Decoder and initial solution are OK"
    else
        @error "Decoder and/or initial solution are NOT OK"
    end

    # brkga_data, control_params = build_brkga(instance, set_cover_decoder, MINIMIZE, 4, instance.num_col, "config.conf")

    # set_initial_population!(brkga_data, [initial_chromosome])
    # initialize!(brkga_data)

    # @time evolve!(brkga_data, 15)

    # best_cost = get_best_fitness(brkga_data)
    # @show best_cost
    return
end

main()