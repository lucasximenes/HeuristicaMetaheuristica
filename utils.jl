mutable struct Solution
    x::Vector{Int64}
    cost::Int64
    covered::Vector{Int64}
end

function checkFeasibility(instance::scpInstance, cols::Vector{Int64})::Bool
    return findfirst(x -> x == 0, sum(instance.m_coverage[:, cols], dims = 2)) === nothing
end