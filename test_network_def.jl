include("CorticalNetworkDefinition.jl")
Network = CorticalNetworkDefinition.Connectivity()
print(size(Network.weights[("4E", "5E")]))
#Network = CorticalNetworkDefinition.Delays()
#print(Network.pops)