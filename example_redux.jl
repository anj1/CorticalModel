using Pkg 

using NetworkDefinition
using Simulator 
using Statistics

params = Dict(
    :threshold_θ => -50.0f-3, # in V
    :membrane_capacitance_C => 250.0f0,  # in pF
    :reset_voltage_V => -65.0f-3,
    :time_constant_memb_τ => 10.0f-3,
    :time_constant_syn_τ => 5.0f-4,
    :refractory_time_t => 2.0f-3
)

pops = Dict(
    "layer1" => NeuronPopulation(1f-4, Float32[0.0f0]),
    "layer2" => NeuronPopulation(1f-4, Float32[0.0f0]),
)

weights = Dict(
    ("layer1", "layer2") => zeros(1,1)
)

inputs = Dict(
    "layer1" => (80f0, 10000f0)
)

net = NeuronNet(pops, weights, params)
