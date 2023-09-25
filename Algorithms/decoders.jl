function set_cover_decoder(vet::Vector{Float64}, instance::scpInstance, rewrite::Bool=false, LS::Bool=false)::Union{Int64, Solution}
    sorted_indices = sortperm(vet)
    covered = zeros(Int64, instance.num_lin)
    count = 0
    cost = 0
    v = Int64[]
    for index in sorted_indices

        cost += instance.v_cost[index]
        push!(v, index)
        for cover in findall(x -> x == 1, instance.m_coverage[:, index])
            covered[cover] += 1
            if covered == 1
                count += 1
                if count == instance.num_lin
                    return LS ? Solution(v, cost, covered) : cost
                end
            end
        end
    end
    return LS ? Solution(v, cost, covered) : cost
end

function set_cover_decoder_LS(vet::Vector{Float64}, instance::scpInstance, neighborhood::Union{OneFlip, TwoFlip})::Solution
    sol = set_cover_decoder(vet, instance, false, true)
    
    viz = neighborhood(instance, sol)
    bestImprovement!(viz)
    return viz.solution
end