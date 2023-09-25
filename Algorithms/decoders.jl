function set_cover_decoder(vet::Vector{Float64}, instance::scpInstance, rewrite::Bool=false, LS::Bool=false)::Int64
    
    sorted_indices = sortperm(vet)
    covered = falses(instance.num_lin)
    count = 0
    cost = 0
    for index in sorted_indices

        cost += instance.v_cost[index]
        for cover in findall(x -> x == 1, instance.m_coverage[:, index])
        
            if !covered[cover]
                covered[cover] = true
                count += 1
                if count == instance.num_lin
                    return cost
                end
            end
        end
    end
end

function set_cover_decoder_LS(vet::Vector{Float64}, instance::scpInstance, rewrite::Bool=false)::Int64
end