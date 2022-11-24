module Simulator

using SparseArrays
using Distributed 

export TemporalBuffer
export NeuronPopulation, NeuronNet
export sim_step!, activation!

include("temporal_buffer.jl")

struct NeuronPopulation
    voltage::Vector{Float32}
    current::Vector{Float32}
    spike::TemporalBuffer{Float32}
    delays::Vector{Float32}
    
    function NeuronPopulation(voltage, current, spike::TemporalBuffer{Float32}, delays)
        new(voltage, current, spike, delays)
    end
end

function NeuronPopulation(dt::Real, delays::Vector{Float32})
    max_time = maximum(delays)
    n = length(delays)

    max_timesteps = ceil(round(Int, max_time / dt))

    tb = TemporalBuffer{Float32}(convert(Float32, dt), spzeros(Float32, n, max_timesteps + 1))
    return NeuronPopulation(zeros(Float32, n), zeros(Float32, n), tb, delays)
end

mutable struct NeuronNet
    pops::Dict{String,NeuronPopulation}
    weights::Dict{Tuple{String,String},AbstractArray}
    params::Dict{Symbol,Float32}
    
    function NeuronNet(pops, weights, params)
        new(pops, weights, params)
    end
end

function NeuronNet()
    pops = Dict{String,NeuronPopulation}()
    weights = Dict{Tuple{String,String},AbstractArray}()
    params = Dict{Symbol,Float32}
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

"""
Add random input currents to the neuron with a given current and rate
"""
function rand_inputs!(pop::NeuronPopulation, cur, rate)
    x_u = rand(length(pop.current))
    x_e = -rate*log.(x_u)  # exponential random var with rate
    cur_in = cur*round.(Int, x_e)  # make discrete spikes, and scale by cur
    pop.current[:] += cur_in
end 

# Update voltages/currents for the neuron population.
function sim_step!(pop::NeuronPopulation, spike::SparseVector{Float32,}, weights::AbstractArray, params)
    # update postsynaptic population given incident voltages

    pop.current[:] += weights * spike

    ### Changes in each time step
    dvoltage_c = pop.current / params[:membrane_capacitance_C]
    dvoltage = ((params[:reset_voltage_V] .- pop.voltage) / params[:time_constant_memb_τ]) .+ dvoltage_c #Specify change in voltage
    dcurrent = -pop.current / params[:time_constant_syn_τ]

    # calculate v_out
    # v_out = voltage + dV??
    pop.voltage[:] += dvoltage * pop.spike.dt
    pop.current[:] += dcurrent * pop.spike.dt
end

# Update spike output for the neuron population.
function activation!(pop::NeuronPopulation, params)
    n = length(pop.voltage)

    for i = 1:n
        max_t = min(params[:refractory_time_t], time_length(pop.spike))
        refr_time = 0.0f0:pop.spike.dt:max_t
        if sum(pop.spike[i, refr_time]) == 0.0f0 && pop.voltage[i] > params[:threshold_θ]
            pop.spike[i] = 1.0f0
            pop.voltage[i] = params[:reset_voltage_V]
        end
    end
end

function sim_step!(net::NeuronNet, inputs=Dict{Symbol,}())

    pop_keys = collect(keys(net.pops))

    delayed_spikes = Dict(key => spike_after_delay(net.pops[key]) for key in pop_keys)

    @sync @distributed for pop_post_key in pop_keys
        pop_post = net.pops[pop_post_key]

        if pop_post_key in keys(inputs)
            cur, rate = inputs[pop_post_key]
            rand_inputs!(pop_post, cur, rate*pop_post.spike.dt)
        end

        for pop_pre_key in pop_keys
            spikes = delayed_spikes[pop_pre_key]

            key = (pop_pre_key, pop_post_key)
            if key in keys(net.weights) 
                sim_step!(pop_post, spikes, net.weights[key], net.params)
            end
        end

        advance!(pop_post.spike)
        activation!(pop_post, net.params)
    end
end


end
