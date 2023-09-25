mutable struct OneFlip
    instance::scpInstance
    solution::Solution
end

function eval(oneFlip::OneFlip, pos::Int64)::Int64
    if !(pos in oneFlip.solution.x)
        return 0
    elseif findfirst(x -> x == 0, oneFlip.solution.covered .- oneFlip.instance.m_coverage[:, pos]) !== nothing
        return 0
    else
        return oneFlip.instance.v_cost[pos] 
    end
end

function move!(oneFlip::OneFlip, pos::Int64)
    oneFlip.solution = Solution(filter(x -> x != pos, oneFlip.solution.x),
     oneFlip.solution.cost - oneFlip.instance.v_cost[pos],
     oneFlip.solution.covered .- oneFlip.instance.m_coverage[:, pos])
end

function bestImprovement!(oneFlip::OneFlip)
    best_reduction = 0
    best_pos = 0
    for i in 1:oneFlip.instance.num_col
        reduction = eval(oneFlip, i)
        if reduction > best_reduction
            best_reduction = reduction
            best_pos = i
        end
    end
    if best_pos != 0
        move!(oneFlip, best_pos)
        bestImprovement!(oneFlip)
    end
    return
end
