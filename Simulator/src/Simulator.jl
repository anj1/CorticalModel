module Simulator 

using SparseArrays

export TemporalBuffer
export NeuronPopulation, NeuronNet
export sim_step!, activation!

include("temporal_buffer.jl")

struct NeuronPopulation
    voltage::Vector{Float32}
    current::Vector{Float32}
    spike::TemporalBuffer{Float32}
    delays

    function NeuronPopulation(voltage, current, spike::TemporalBuffer{Float32}, delays)
        new(voltage, current, spike, delays)
    end
end

function NeuronPopulation(dt, delays)
    max_time = maximum(delays)
    n = length(delays)

    max_timesteps = ceil(round(Int, max_time / dt))

    tb = TemporalBuffer{Float32}(dt, spzeros(Float32, n, max_timesteps + 1))
    return NeuronPopulation(zeros(Float32, n), zeros(Float32, n), tb, delays)
end

function Base.copy(pop::NeuronPopulation)
    return NeuronPopulation(copy(pop.spike), copy(pop.delays))
end

mutable struct NeuronNet
    pops::Dict{String,NeuronPopulation}
    weights::Dict{Tuple{String,String},AbstractArray}
	params::Dict{Symbol, Float32}
	
    function NeuronNet(pops, weights, params)
        new(pops, weights, params)
    end
end

function NeuronNet()
    pops = Dict{String,NeuronPopulation}()
    weights = Dict{Tuple{String,String},AbstractArray}()
	params = Dict{Symbol, Float32}
    new(pops, weights, params)
end

function spike_after_delay(pop::NeuronPopulation)
    spike = spzeros(Float32, length(pop.delays))
    for i = 1:length(pop.delays)
        # This will automatically skip storing zeros
        spike[i] = pop.spike[i, pop.delays[i]]
    end

    return spike
end

function sim_step!(pop::NeuronPopulation, spike::SparseVector{Float32,}, weights::AbstractArray, params)
    # update postsynaptic population given incident voltages
    pop.current[:] += weights*spike

    ### Changes in each time step
	dvoltage_c = pop.current / params[:membrane_capacitance_C]
    dvoltage = ((params[:reset_voltage_V] .- pop.voltage ) / params[:time_constant_memb_τ]) .+ dvoltage_c #Specify change in voltage
    dcurrent = -pop.current / params[:time_constant_syn_τ]

    # calculate v_out
    # v_out = voltage + dV??
    pop.voltage[:] += dvoltage * pop.spike.dt 
    pop.current[:] += dcurrent * pop.spike.dt 
end

function activation!(pop::NeuronPopulation, params)
    n = length(pop.voltage)

    for i = 1:n
		refr_time = 0.0f0:pop.spike.dt:params[:refractory_time_t]
        if sum(pop.spike[i, refr_time]) == 0.0f0 && pop.voltage[i] > params[:threshold_θ]
            pop.spike[i] = 1.0f0
            pop.voltage[i] = params[:reset_voltage_V]
        end
    end
end

function sim_step!(pop_post::NeuronPopulation, pop_pre::NeuronPopulation, weights::AbstractArray, params)
    spike = spike_after_delay(pop_pre)  # todo: don't recompute this for every pop_pre

    sim_step!(pop_post, spike, weights, params)
end

function sim_step!(net::NeuronNet)
    new_pops = Dict{String,NeuronPopulation}()

    pop_keys = keys(net.pops)
    for pop_post_key in pop_keys
        pop_post = copy(net.pops[pop_post_key])

        advance!(pop_post.spike)

        for pop_pre_key in pop_keys
            pop_pre = net.pops[pop_pre_key]
            key = (pop_pre_key, pop_post_key)
            if key in keys(net.weights)
                weights = net.weights[key]

                sim_step!(pop_post, pop_pre, weights, net.params)
            end
        end

        activation!(pop_post, net.params)

        new_pops[pop_post_key] = pop_post

    end

    net.pops = new_pops
end


end
