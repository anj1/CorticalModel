include("CorticalNetworkDefinition.jl")
network = CorticalNetworkDefinition.connectivity
print(size(network.weights[("4E", "5E")]))
Network = CorticalNetworkDefinition.delays
print(network.pops)