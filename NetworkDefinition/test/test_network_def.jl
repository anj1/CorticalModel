include("CorticalNetworkDefinition.jl")
include("src/main.jl")
network = CorticalNetworkDefinition.connectivity
print(size(network.weights[("2/3I", "5I")]))
print(keys(network.pops))
