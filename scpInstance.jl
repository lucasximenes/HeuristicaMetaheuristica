struct scpInstance <: AbstractInstance
    num_lin::Int64#Number of lines
    num_col::Int64 #Number of columns
    v_cost::Array{Int64}#Vector of costs
    m_coverage::Array{Int64,2}#Matrix of coverage
    

    function scpInstance(filename::String)

        f = open(filename)
        s = read(f, String)
        values = split(s)

        v = 1 
        num_lin = parse(Int64, values[v])
        
        v = v+1
        num_col = parse(Int64, values[v])
        
                                
        v_cost = Array{Int64,1}(undef,num_col)
        for j = 1:num_col
            v_cost[j]=parse(Int64, values[j+2])
        end  

        v= v + num_col # v = num_col + 2
        
        m_coverage = zeros(Int64, num_lin, num_col)

        for i = 1:num_lin
            v=v+1
            cl = parse(Int64, values[v])

            for j = 1:cl
                v=v+1
                j = parse(Int64, values[v])
                m_coverage[i,j]=1
            end

        end

        new(num_lin, num_col, v_cost, m_coverage)
    end
end

function make_instance(m, n, filename)
    servidos = [false for i in 1:n]
    open("$filename.txt", "w") do f
        write(f, "$m $n\n")
        for j in 1:n
            write(f, "$(rand(1:4)) ")
        end
        write(f, "\n")
        for i in 1:m
            qntd = rand(1:5)
            write(f, "$qntd ")
            for j in 1:qntd
                num = rand(1:n)
                servidos[num] = true
                write(f, "$num ")
            end
            for j in 1:n
                if !servidos[j]
                    write(f, "$j ")
                end
            end
            write(f, "\n")
        end
    end
end