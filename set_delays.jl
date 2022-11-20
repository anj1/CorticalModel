function set_delays(d_ex, std_d_ex, d_in, std_d_in, n_layer_dict, network, timestep)
    for (key, _) in n_layer_dict
        if occursin("E", key) == true
            d = d_ex
            d_std = std_d_ex
        else
            occursin("I", key) == true
            d = d_in
            d_std = std_d_in
        end
        delays = Float32.(d_std * randn(n_layer_dict[key]))
        network.pops[key] = NeuronPopulation(timestep, abs.(delays))
    end
    return network
end
