include("CorticalNetworkDefinition.jl")
network = CorticalNetworkDefinition.connectivity
print(size(network.weights[("4E", "5E")]))
print(network.pops)