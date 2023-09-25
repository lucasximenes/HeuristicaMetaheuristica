mutable struct Solution
    x::Vector{Int64}
    cost::Int64
    covered::Vector{Int64}
end

function checkFeasibility(instance::scpInstance, cols::Vector{Int64})::Bool
    return findfirst(x -> x == 0, sum(instance.m_coverage[:, cols], dims = 2)) === nothing
end

function buildChromosome(instance::scpInstance, sol::Solution)::Vector{Float64}
    rand_keys = rand(instance.num_col)
    keys = sort(rand_keys)
    initial_chromosome = zeros(instance.num_col)
    for i in 1:instance.num_col
        if i > length(sol.v)
            initial_chromosome[setdiff(collect(1:instance.num_col), sol.v)] = keys[i:end]
            break
        end
        initial_chromosome[v[i]] = keys[i]
    end
end