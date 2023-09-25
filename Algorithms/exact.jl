using JuMP, HiGHS, SparseArrays

function solve_instance(instance::scpInstance)
    A = sparse(instance.m_coverage)
    m, n = size(A)
    C = instance.v_cost
    
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    @variable(model, x[1:n], Bin)

    @constraint(model, [i in 1:m], sum(A[i, j] * x[j] for j in 1:n) >= 1)
    @objective(model, Min, sum(C[j] * x[j] for j in 1:n))

    optimize!(model)
    return objective_value(model), value.(x), termination_status(model)
end