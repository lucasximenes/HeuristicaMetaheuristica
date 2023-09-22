function constByCost(instance::scpInstance)
    
    descoberto = true
    v_cobertura = zeros(Int64, instance.num_lin)

    v_sol = zeros(Int64, instance.num_col)
    cost_sol = 0

    v_ind = sortperm(instance.v_cost)

    j=1
    while descoberto
        coluna = v_ind[j]
        v_sol[coluna]=1
        cost_sol = cost_sol + instance.v_cost[coluna]

        descoberto = false
        for linha = 1:instance.num_lin
            v_cobertura[linha] = v_cobertura[linha] + instance.m_coverage[linha,coluna]
            if v_cobertura[linha]==0 
                descoberto = true
            end
        end

        j=j+1
    end
    return v_sol, cost_sol, v_cobertura
end




### checar se não precisar tirar a coluna construida da matriz de cobertura
function outroConst(instance::scpInstance)
    v_sol = []
    v_coverage = [0 for i in 1:instance.num_lin]
    cost = 0
    uncovered = instance.num_lin
    
    while uncovered > 0
        
        indices = findall(x -> x == 0, v_coverage)
        coverages = [sum(instance.m_coverage[i, j] for i in indices) for j in 1:instance.num_col]
        ratios = instance.v_cost ./ coverages

        best_col = argmin(ratios)
        cost += instance.v_cost[best_col]

        push!(v_sol, best_col)

        for index in findall(x -> x == 1, instance.m_coverage[:, best_col])
            if v_coverage[index] == 0
                uncovered -= 1
            end
            v_coverage[index] += 1
        end
    end

    return v_sol, cost, v_coverage
end


