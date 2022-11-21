module CorticalNetworkDefinition

export Network
export NeuronPopulation
export sim_step!

using CSV
using DataFrames
include("src/connectivity.jl")
include("set_delays.jl")
include("src/main.jl")
include("src/temporal_buffer.jl")

##### Define Network Parameters & Connectivity Table #####
l_name = ["2/3E", "2/3I", "4E", "4I", "5E", "5I", "6E", "6I"]
x = [1148, 324, 268, 60, 1216, 304, 800, 164, 657]
n_layer = [i * 9 for i in x]
df = DataFrame(CSV.File("shimoura11_spatial.csv"))
threshold_θ = -50e-3 
membrane_capacitance_C = 250e-12 
reset_voltage_V = -65e-3 
time_constant_memb_τ = 10e-3 
time_constant_syn_τ = 10e-3
refractory_time_t = 2e-3 


##### Define Delay Parameters #####
d_ex = 1.5e-3     # Excitatory delay
std_d_ex = 0.75e-3 # Std. Excitatory delay
d_in = 0.80e-3      # Inhibitory delay
std_d_in = 0.4e-3  # Std. Inhibitory delay
n_layer_dict = Dict(zip(l_name, n_layer))
pA = 1
##### Create Network #####

function make_default_net()
    Network = NeuronNet()

    connectivity = add_network_connections(df, n_layer_dict, Network, "Random")
    delays = set_delays(d_ex, std_d_ex, d_in, std_d_in, n_layer_dict, Network, 1e-4)

    return connectivity, delays
end 



end
