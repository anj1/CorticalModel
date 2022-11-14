using Unitful 

include("temporal_buffer.jl")

struct NeuronPopulation
	v::TemporalBuffer{Float32}
	delays
	
    function NeuronPopulation(v::TemporalBuffer{Float32}, delays)
        new(v, delays)
    end 
end 

function NeuronPopulation(dt, delays)
    max_time = maximum(delays) 
	n_neurons = length(delays)
    
	max_timesteps = ceil(round(Int, max_time/dt))
	
	tb = TemporalBuffer{Float32}(dt, zeros(n_neurons, max_timesteps))
	return NeuronPopulation(tb, delays)
end 

function Base.copy(pop::NeuronPopulation)
    return NeuronPopulation(copy(pop.v), copy(pop.delays))
end 

mutable struct NeuronNet
	pops::Dict{String, NeuronPopulation}
	weights::Dict{Tuple{String,String}, AbstractArray}
	
	function NeuronNet()
		pops = Dict{String, NeuronPopulation}()
		weights = Dict{Tuple{String,String}, AbstractArray}()
		new(pops, weights)
	end
end 

function v_after_delay(pop::NeuronPopulation)
	v = Array{Float32}(undef, (length(pop.v),))
	
	for i = 1:length(pop.v)
		v[i] = v[i, delays[i]]
	end 
	
	return v
end 


function sim_step!(pop::NeuronPopulation, v::Vector{Float32}, weights::AbstractArray)
  # update postsynaptic population given incident voltages

  # calculate v_out
  # v_out = your equation, including action potentials, ...
  # pop.v += ...
end 


function sim_step!(pop_pre::NeuronPopulation, pop_post::NeuronPopulation, weights::AbstractArray)
	v = v_after_delay(pop_pre)
	
	sim_step!(pop_post, v, weights)
end

function sim_step!(net::NeuronNet)
	new_pops = Dict{String, NeuronPopulation}()
	
	pop_keys = keys(net.pops)
	for pop_post_key in pop_keys
        @show pop_post_key
		pop_post = copy(net.pops[pop_post_key])
		
		advance!(pop_post.v)
		
		for pop_pre_key in pop_keys
			pop_pre = net.pops[pop_pre_key]
			weights = net.weights[(pop_pre_key, pop_post_key)]
			
			sim_step!(pop_post, pop_pre, weights) 
		end 
		
		activate!(pop_post) 
		
		new_pops[pop_post_key] = pop_post 
	end 
	
	net.pops = new_pops 
end 
