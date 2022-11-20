include("CorticalNetworkDefinition.jl")
network = CorticalNetworkDefinition.connectivity
print(size(network.weights[("4E", "5E")]))
print(keys(network.pops))

using .CorticalNetworkDefinition

function CorticalNetworkDefinition.sim_step!(pop::NeuronPopulation, v::Vector{Float32}, weights::AbstractArray)
    # update postsynaptic population given incident voltages

    # calculate v_out
    # v_out = your equation, including action potentials, ...
    pop.v[:] += (v'*weights)'
end 

function CorticalNetworkDefinition.activation!(pop::NeuronPopulation)
    firing_threshold = -55e-3
    reset_v = -60e-3

    for i = 1:length(pop.delays)
        if pop.v[i] > firing_threshold
            pop.v[i] = reset_v
        end 
    end
end


@time sim_step!(network)

println(network.pops["2/3E"].v.buf[:,1])

@time sim_step!(network)

println(network.pops["2/3E"].v.buf[:,1])
println(network.pops["2/3E"].v.buf[:,2])
