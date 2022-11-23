using Pkg 
Pkg.develop(path="./Simulator")
Pkg.develop(path="./NetworkDefinition")

using NetworkDefinition
using Simulator 

net = create_default_network()
net = add_input(net)

sim_step!(net)

@show net.pops["2/3E"].current