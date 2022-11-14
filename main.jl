using Unitful 

mutable struct NeuronNet
	pops::Dict{String, NeuronPopulation}
	weights::Dict{Tuple{String,String}, AbstractArray}
end 

struct NeuronPopulation
	v::TemporalBuffer{Float32}
	delays
end 

function v_after_delay(pop:NeuronPopulation)
	v = Array{Float32}(undef, (length(pop.v),))
	
	for i = 1:length(pop.v)
		v[i] = v[i, delays[i]]
	end 
	
	return v
end 

function sim_step!(pop_post::NeuronPopulation, pop_pre::NeuronPopulation, weights)
	# Get voltages feeding from presynaptic neurons to postsynaptic neurons, 
	# taking delay into account. 
	v = 
end 

function sim_step!(net::NeuronNet)
	new_pops = Dict{String, NeuronPopulation}()
	
	pop_keys = keys(net.pops)
	for pop_post_key in pop_names 
		pop_post = copy(net.pops[pop_post_key])
		
		advance!(pop_post.v)
		
		for pop_pre_key in pop_names
			pop_pre = net.pops[pop_pre_name]
			weights = net.weights[(pop_pre, pop_post)]
			
			sim_step!(pop_post, pop_pre, weights) 
		end 
		
		new_pops[pop_post_key] = pop_post 
	end 
	
	net.pops = new_pops 
end 