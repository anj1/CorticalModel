using Random
using StatsBase
using SparseArrays

function calculate_nsyn(src, tgt, prob, n_layer_dict)
    #This function finds the number of synapses between neural populations based on Peter's rule
    return nsyn = round(Int, log(1.0 - prob) / log(1.0 - (1.0 / (n_layer_dict[src] * n_layer_dict[tgt]))))
end

function find_p(src, tgt, n_layer_dict, start_dict, stop_dict, X, Y, Z, radius)
    #This function defines the weights for probabilities of connections based on distance
    p = zeros(trunc(Int, n_layer_dict[src]), trunc(Int, n_layer_dict[tgt]))
    array_X_src = ones((n_layer_dict[src], n_layer_dict[tgt])) .* X[start_dict[src]:stop_dict[src]]
    array_X_tgt = ones((n_layer_dict[src], n_layer_dict[tgt])) .* transpose(X[start_dict[tgt]:stop_dict[tgt]])

    array_Y_src = ones((n_layer_dict[src], n_layer_dict[tgt])) .* Y[start_dict[src]:stop_dict[src]]
    array_Y_tgt = ones((n_layer_dict[src], n_layer_dict[tgt])) .* transpose(Y[start_dict[tgt]:stop_dict[tgt]])

    p = 1 .* exp.(-((((array_X_src - array_X_tgt) .^ 2) + (array_Y_src - array_Y_tgt) .^ 2) ./ (2 * radius^2)))

    #if src == tgt
    #    p[diagind(p)] .= 0.0 #prevent self connections
    #end
    return p
end

function group_start_stop(n_layer_dict)
    #This function creates dictionaries of start and stop indices for neutron groups
    l_name = keys(n_layer_dict)
    layer_indices = cumsum(values(n_layer_dict))
    start = vcat([1], layer_indices[1:7] .+ 1)
    stop = layer_indices
    start_dict = Dict(zip(l_name, start))
    stop_dict = Dict(zip(l_name, stop))
    return start_dict, stop_dict
end

function define_position(n_layer_dict, n_cols, X_col, Y_col, Z_col, space)
    #This function determines the X, Y, Z position of neutrons in the model
    ##### Define X, Y, Z Positions #####
    #n_cols = 9; X_col = 300; Y_col = 300; Z_col = 2300; space = 50
    X = []
    Y = []
    Z = []
    num = [round(x / n_cols) for x in values(n_layer_dict)]
    dim = sqrt(n_cols)

    #Define X, Y locations
    for i in 1:length(num)
        for j in 1:n_cols
            append!(X, rand(0:X_col, convert(Int, num[i])) .+ (space * rem(j - 1, dim) + rem(j - 1, dim) * (X_col)))
            append!(Y, rand(0:Y_col, convert(Int, num[i])) .+ (fld(j - 1, dim) * (Y_col + space)))
        end
    end

    #Define Z locations
    layers = [filter(isdigit, collect(s)) for s in keys(n_layer_dict)]
    groups = unique!(layers)
    value = [v for v in values(n_layer_dict)]
    group_num = zeros(length(groups))
    for s in keys(n_layer_dict)
        for (i, g) in enumerate(groups)
            if occursin(g[1], s)
                group_num[i] += n_layer_dict[s]
            end
        end
    end
    g_idx = [parse(Int, k[1]) for k in groups]
    Z_Dict = Dict(zip(g_idx, group_num))
    b = zeros(length(groups) + 1)
    for (i, x) in enumerate(values(sort(collect(Z_Dict), by=x -> x[1])))
        b[i+1] = b[i] + Z_col * (x[2] / sum(value))
    end
    boundaries = Z_col .- b
    layers = [filter(isdigit, collect(s)) for s in keys(n_layer_dict)]
    for (i, x) in enumerate(layers)
        l = parse(Int, x[end])
        append!(Z, rand(boundaries[l-1]:boundaries[l-2], value[i]))
    end

    return X, Y, Z
end

function random_connections(n_layer_dict, src, tgt, nsyn)
    #This function creates random based connections
    src_idx = Array{Int64}(undef, nsyn)
    tgt_idx = Array{Int64}(undef, nsyn)
    for i in 1:nsyn
        src_idx[i] = rand(1:n_layer_dict[src])
        tgt_idx[i] = rand(1:n_layer_dict[tgt])
    end

    return src_idx, tgt_idx
end

function spatial_connections(n_layer_dict, src, tgt, nsyn)
    ### This function creates spatially defined connections
    start_dict, stop_dict = group_start_stop(n_layer_dict)
    pre_idx = rand(1:n_layer_dict[src], nsyn)
    pre_dict = countmap([c for c in pre_idx])
    tgt_idx = zeros(nsyn)
    pre_indices = zeros(nsyn)
    v_array = [v for v in values(pre_dict)]
    num_conn = vcat([1], v_array)
    X, Y, Z = define_position(n_layer_dict, 9, 300, 300, 300, 50)
    p = find_p(src, tgt, n_layer_dict, start_dict, stop_dict, X, Y, Z, 50)
    for (i, p_oi) in enumerate(keys(pre_dict))
        a = range(1, n_layer_dict[tgt])
        point_oi = round(Int, p_oi)
        w = p[point_oi, :]
        tgt_idx[round(Int, sum(num_conn[1:i])):round(Int, sum(num_conn[1:i+1]) - 1)] = sample(a, Weights(w), num_conn[i+1])
        pre_indices[round(Int, sum(num_conn[1:i])):round(Int, sum(num_conn[1:i+1]) - 1)] .= point_oi
    end
    src_idx = pre_indices
    return src_idx, tgt_idx
end

function create_submatrix(n_layer_dict, src, tgt, nsyn, src_idx, tgt_idx, std, weight)
    #This function creates connectivity matrices for each population based connection 
    submatrix = zeros(Float32, (n_layer_dict[src], n_layer_dict[tgt]))

    for i in 1:nsyn
        submatrix[round(Int, src_idx[i]), round(Int, tgt_idx[i])] += std * randn() + weight
    end

    return submatrix
end


function add_network_connections(df, n_layer_dict, network, type)
    #This function adds connections to the neural network
    num_conn = size(df)[1]
    pA = 1.0
    for row_n in 1:num_conn
        weight = eval(Meta.parse(df[row_n, "Weight"]))
        std = eval(Meta.parse(df[row_n, "Wstd"]))
        src = df[row_n, :].Source * df[row_n, :].SourceType
        tgt = df[row_n, :].Target * df[row_n, :].TargetType
        nsyn = calculate_nsyn(src, tgt, df[row_n, :].Pmax, n_layer_dict)
        println(src, " to ", tgt)
        println("Num Syn = ", nsyn)
        #pA = u"pA"
        if type == "Spatial"
            src_idx, tgt_idx = spatial_connections(n_layer_dict, src, tgt, nsyn)
        elseif type == "Random"
            src_idx, tgt_idx = random_connections(n_layer_dict, src, tgt, nsyn)
        end
        network.weights[(src, tgt)] = create_submatrix(n_layer_dict, src, tgt, nsyn, src_idx, tgt_idx, std, weight)
    end
    return network
end


function create_submatrix_sparse(src, tgt, prob, n_layer_dict, row_n)
    pA = 1.0

    weight = eval(Meta.parse(df[row_n, "Weight"]))
    std = eval(Meta.parse(df[row_n, "Wstd"]))
    @time submatrix = weight .+ (std .* sprandn(Float32, n_layer_dict[src], n_layer_dict[tgt], prob))

    submatrix = convert(Array, submatrix)

    return submatrix
end