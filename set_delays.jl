function SetDelays(n_layer_dict, Network, timestep, NeuronPopulation())
	for (key, value) in n_layer_dict
    		if occursin("E", key) == true
        		d = d_ex
       			d_std = std_d_ex
        	else occursin("I", key) == true
        		d = d_in
        		d_std = std_d_in
    		end
    		a= Normal(d, d_std)
    		delays=Float32.(rand(a, n_layer_dict[key]))
    		Network.pops[key] = NeuronPopulation(timestep, abs.(delays))
	end
	return network
end