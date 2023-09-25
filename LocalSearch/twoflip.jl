mutable struct TwoFlip
    instance::scpInstance
    solution::Solution
end

function eval(twoFlip::TwoFlip, pos1::Int64, pos2::Int64)::Int64
    if !(pos1 in twoFlip.solution.x) && !(pos2 in twoFlip.solution.x)
        return 0
    end

    in1 = pos1 in twoFlip.solution.x ? 1 : -1
    in2 = pos2 in twoFlip.solution.x ? 1 : -1

    if findfirst(x -> x == 0, twoFlip.solution.covered .- (twoFlip.instance.m_coverage[:, pos1] * in1) .- (twoFlip.instance.m_coverage[:, pos2] * in2)) !== nothing
        return 0
    else
        return (twoFlip.instance.v_cost[pos1] * in1) + (twoFlip.instance.v_cost[pos2] * in2)
    end

end

function move!(twoFlip::TwoFlip, pos1::Int64, pos2::Int64)
    
    new_x = copy(twoFlip.solution.x)
    for pos in (pos1, pos2)
        if pos in new_x
            deleteat!(new_x, findfirst(x -> x == pos, new_x))
        else
            push!(new_x, pos)
        end
    end
            
    in1 = pos1 in twoFlip.solution.x ? 1 : -1
    in2 = pos2 in twoFlip.solution.x ? 1 : -1

    twoFlip.solution = Solution(new_x,
     twoFlip.solution.cost - (twoFlip.instance.v_cost[pos1] * in1) - (twoFlip.instance.v_cost[pos2] * in2),
     twoFlip.solution.covered .- (twoFlip.instance.m_coverage[:, pos1] * in1) .- (twoFlip.instance.m_coverage[:, pos2] * in2))
end


function bestImprovement!(twoFlip::TwoFlip)
    best_reduction = 0
    best_pos = (0, 0)
    for i in 1:twoFlip.instance.num_col - 1
        for j in i + 1:twoFlip.instance.num_col
            reduction = eval(twoFlip, i, j)
            if reduction > best_reduction
                best_reduction = reduction
                best_pos = (i, j)
            end
        end
    end

    if best_pos != (0, 0)
        move!(twoFlip, best_pos[1], best_pos[2])
        bestImprovement!(twoFlip)
    end
    return
end
