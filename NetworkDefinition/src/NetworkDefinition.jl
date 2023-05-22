module NetworkDefinition

export create_default_network, add_input

using CSV
using DataFrames

using Simulator

include("connectivity.jl")
include("set_delays.jl")


function create_default_network(con_type="Random"; def_path=nothing)
    # Units:
    # current: pA,
    # capacitance: pF
    # voltage: V
    # time: s

    ##### Define Network Parameters #####
    params = Dict(
        :threshold_θ => -50.0f-3, # in V
        :membrane_capacitance_C => 250.0f0,  # in pF
        :reset_voltage_V => -65.0f-3,
        :time_constant_memb_τ => 10.0f-3,
        :time_constant_syn_τ => 5.0f-4,
        :refractory_time_t => 2.0f-3
    )

    ##### Define Delay Parameters #####
    d_ex = 1.5f-3     # Excitatory delay
    std_d_ex = 0.75f-3 # Std. Excitatory delay
    d_in = 0.80f-3      # Inhibitory delay
    std_d_in = 0.4f-3  # Std. Inhibitory delay

    ##### Define connectivity table #####
    l_name = ["2/3E", "2/3I", "4E", "4I", "5E", "5I", "6E", "6I"]
    x = [1148, 324, 268, 60, 1216, 304, 800, 164]
    n_layer = [i * 9 for i in x]

    n_layer_dict = Dict(zip(l_name, n_layer))

    if def_path == nothing
        def_path = joinpath(dirname(dirname(pathof(NetworkDefinition))), "data", "shimoura11_spatial.csv")
    end
    df = DataFrame(CSV.File(def_path))

    populations = create_neuron_populations(d_ex, std_d_ex, d_in, std_d_in, n_layer_dict, 1e-4, params[:reset_voltage_V])
    weights = create_network_connections(df, n_layer_dict, con_type)
    return NeuronNet(populations, weights, params)
end

function add_input(network)
    l_name = ["2/3E", "2/3I", "4E", "4I", "5E", "5I", "6E", "6I"]
    x = [1148, 324, 268, 60, 1216, 304, 800, 164]
    n_layer = [i * 9 for i in x]

    n_layer_dict = Dict(zip(l_name, n_layer))

    network = create_input(network, n_layer_dict, 1e-4)
    return network
end

end
