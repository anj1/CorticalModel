using Random

function calculate_nsyn(src, tgt, prob, n_layer_dict)
	return nsyn = round(Int, log(1.0-prob)/log(1.0 - (1.0/(n_layer_dict[src]*n_layer_dict[tgt]))))
end

function create_submatrix(src, tgt, prob, n_layer_dict, row_n)
    nsyn = calculate_nsyn(src, tgt, prob, n_layer_dict)

    #pA = u"pA"
    pA = 1.0
    weight = eval(Meta.parse(df[row_n,"Weight"]))
    std = eval(Meta.parse(df[row_n,"Wstd"]))
    
    submatrix = zeros(Float32, (n_layer_dict[src], n_layer_dict[tgt]))

    for i in 1:nsyn
        src_idx = rand(1:n_layer_dict[src])
        tgt_idx = rand(1:n_layer_dict[tgt])

        submatrix[src_idx, tgt_idx] = std*randn() + weight
    end

	return submatrix
end


function add_network_connections(df, n_layer_dict, network)
    num_conn = size(df)[1]
    for row_n in 1:num_conn
        src = df[row_n,:].Source*df[row_n,:].SourceType
        tgt = df[row_n,:].Target*df[row_n,:].TargetType

        network.weights[(src, tgt)] = create_submatrix(src, tgt, df[row_n,:].Pmax, n_layer_dict, row_n)
    end
    return network
end


