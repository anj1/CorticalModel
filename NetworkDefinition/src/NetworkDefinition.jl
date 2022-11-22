module NetworkDefinition

export create_default_net

using CSV
using DataFrames

using Simulator 

include("connectivity.jl")
include("set_delays.jl")

##### Define Network Parameters #####
threshold_θ = -50f-3 
membrane_capacitance_C = 250f-12 
reset_voltage_V = -65f-3 
time_constant_memb_τ = 10f-3 
time_constant_syn_τ = 10f-3
refractory_time_t = 2f-3 

##### Define Delay Parameters #####
d_ex = 1.5f-3     # Excitatory delay
std_d_ex = 0.75f-3 # Std. Excitatory delay
d_in = 0.80f-3      # Inhibitory delay
std_d_in = 0.4f-3  # Std. Inhibitory delay
pA = 1
##### Create Network #####

function create_default_net()
    ##### Define connectivity table #####
    l_name = ["2/3E", "2/3I", "4E", "4I", "5E", "5I", "6E", "6I"]
    x = [1148, 324, 268, 60, 1216, 304, 800, 164, 657]
    n_layer = [i * 9 for i in x]

    n_layer_dict = Dict(zip(l_name, n_layer))

    df = DataFrame(CSV.File("../data/shimoura11_spatial.csv"))

    populations = create_populations(d_ex, std_d_ex, d_in, std_d_in, n_layer_dict, 1e-4)
    weights = create_network_connections(df, n_layer_dict, "Random")

    return NeuronNet(populations, weights)
end 



end
