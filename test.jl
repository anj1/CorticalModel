include("src/main.jl")
include("src/temporal_buffer.jl")

function sim_step!(pop::NeuronPopulation, v::Vector{Float32}, weights::AbstractArray)
    # update postsynaptic population given incident voltages

    # calculate v_out
    # v_out = your equation, including action potentials, ...
    # pop.v += ...

    pop.v.buf[:,1] = weights*v
end 

function activation!(pop::NeuronPopulation)
    
end 

function test_pop_update()
    pop_pre = NeuronPopulation(1e-3, Float32[0, 1e-3])
    pop_post = NeuronPopulation(1e-3, Float32[0, 0, 1e-3])

    weights = randn(Float32, (3, 2))

    sim_step!(pop_post, pop_pre, weights)

    @show pop_post.v
end 



function test_net_update()
    pop_pre = NeuronPopulation(1e-3, Float32[0, 1e-3])
    pop_post = NeuronPopulation(1e-3, Float32[0, 0, 1e-3])

    weights = randn(Float32, (3, 2))

    

    net = NeuronNet()
    net.pops["1"] = pop_pre 
    net.pops["2"] = pop_post
    net.weights[("1", "2")] = weights 

    sim_step!(net)

    @show net.pops["2"].v
end 

test_pop_update()
test_net_update()