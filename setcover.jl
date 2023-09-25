using Random, Statistics, BrkgaMpIpr

include("Data/scpInstance.jl")
include("Algorithms/construtivos.jl")
include("Algorithms/decoders.jl")
include("benchmark.jl")
include("utils.jl")
include("LocalSearch/oneflip.jl")

function main()

    instance = scpInstance("./data/scp41.txt")

    v, cost, cov = outroConst(instance)

    rand_keys = rand(instance.num_col)
    keys = sort(rand_keys)
    initial_chromosome = zeros(instance.num_col)
    for i in 1:instance.num_col
        if i > length(v)
            initial_chromosome[setdiff(collect(1:instance.num_col), v)] = keys[i:end]
            break
        end
        initial_chromosome[v[i]] = keys[i]
    end

    #=
    checa se decoder está correto, e se o custo da solução obtida pelo construtivo 
    encodado no cromossomo é o mesmo que o custo da solução original
    =#
    if (set_cover_decoder(initial_chromosome, instance, false) == cost)
        @info "Decoder and initial solution are OK"
    else
        @error "Decoder and/or initial solution are NOT OK"
    end

    brkga_data, control_params = build_brkga(instance, set_cover_decoder, MINIMIZE, 4, instance.num_col, "config.conf")

    set_initial_population!(brkga_data, [initial_chromosome])
    initialize!(brkga_data)

    @time evolve!(brkga_data, 15)

    best_cost = get_best_fitness(brkga_data)
    @show best_cost
end

main()