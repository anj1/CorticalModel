function create_neuron_populations(d_ex, std_d_ex, d_in, std_d_in, n_layer_dict, timestep)
    pops = Dict{String,NeuronPopulation}()

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
        pops[key] = NeuronPopulation(timestep, abs.(delays))
    end

    return pops
end

function create_input(net, n_layer_dict, timestep)
    println("create input pop")
    input_pop = NeuronPopulation(timestep, zeros(Float32, n_layer_dict["2/3E"]))
    println("define spikes")
    println(size(input_pop.spike.buf))
    #input_pop.spike.buf = zeros(Float32, n_layer_dict["2/3E"])
    input_pop.spike.buf[1, 1] = 1

    println("add to network population")
    net.pops["Input"] = input_pop

    println("define weights")
    weights = zeros(Float32, n_layer_dict["2/3E"], n_layer_dict["2/3E"])
    weights[3:5, 1] .= 1

    net.weights["Input", "2/3E"] = weights

    return net

end