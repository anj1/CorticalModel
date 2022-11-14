using Random, Distributions

function CalculateNsyn(src, tgt, prob, n_layer_dict)
	return nsyn = round(Int, log(1.0-prob)/log(1.0 - (1.0/(n_layer_dict[src]*n_layer_dict[tgt]))))
end

function CreateSubmatrix(src, tgt, prob, n_layer_dict, row_n)
	#println(src, " to ", tgt)
    	nsyn = CalculateNsyn(src, tgt, prob, n_layer_dict)
    	#println("Num Syn:", nsyn)
    	src_idx = rand(1:n_layer_dict[src], nsyn)
    	tgt_idx = rand(1:n_layer_dict[tgt], nsyn)
    	#pA = u"pA"
    	Weight = eval(Meta.parse(df[row_n,:].Weight))
    	Wstd = eval(Meta.parse(df[row_n,:].Wstd))
    	d = Normal(Weight, Wstd) #ustrip
    	weights=rand(d,nsyn) #* u"pA"
    	submatrix = Array{Float32, 2}(undef, n_layer_dict[src], n_layer_dict[tgt])
    	for i in 1:nsyn
        	submatrix[src_idx[i], tgt_idx[i]] = weights[i]
    	end
	return submatrix
end


function addNetworkConnections(df, n_layer_dict, network)
	num_conn = size(df)[1]
	for row_n in 1:num_conn
		src = df[row_n,:].Source*df[row_n,:].SourceType
		tgt = df[row_n,:].Target*df[row_n,:].TargetType
    		network.weights[(src, tgt)] = CreateSubmatrix(src, tgt, df[row_n,:].Pmax, n_layer_dict, row_n)
	end
	return network
end


