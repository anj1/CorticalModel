include("defineNetwork.jl")
#Network = defineNetwork.connectivity
#print(size(Network.weights[("4E", "5E")]))
Network = defineNetwork.delays
print(keys(Network.pops))