using Pkg 
Pkg.develop(path="./Simulator")
Pkg.develop(path="./NetworkDefinition")

using NetworkDefinition
using Simulator 

net = create_default_network()

# Give population 2/3E a set of inputs with synaptic current 80.0 pA,
# and collective firing rate of 8 Hz x 2000 synapses
inputs = Dict("2/3E" => (80.0, 8f0*2000))

sim_step!(net, inputs)

@show net.pops["2/3E"].current