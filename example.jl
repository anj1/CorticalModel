using Pkg 
Pkg.develop(path="./Simulator")
Pkg.develop(path="./NetworkDefinition")

using NetworkDefinition

net = create_default_network()
