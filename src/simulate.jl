#using Unitful 

include("temporal_buffer.jl")

struct NeuronPopulation
    voltage::Vector{Float32}
    current::Vector{Float32}
    spike::TemporalBuffer{Float32}
    delays
    dt

    function NeuronPopulation(voltage, current, spike::TemporalBuffer{Float32}, delays, dt)
        new(voltage, current, spike, delays, dt)
    end
end

function NeuronPopulation(dt, delays)
    max_time = maximum(delays)
    n_neurons = length(delays)

    max_timesteps = ceil(round(Int, max_time / dt))

    tb = TemporalBuffer{Float32}(dt, spzeros(Float32, n_neurons, max_timesteps + 1))
    return NeuronPopulation(zeros(Float32, n), zeros(Float32, n), tb, delays, dt)
end

function Base.copy(pop::NeuronPopulation)
    return NeuronPopulation(copy(pop.spike), copy(pop.delays))
end

mutable struct NeuronNet
    pops::Dict{String,NeuronPopulation}
    weights::Dict{Tuple{String,String},AbstractArray}

    function NeuronNet()
        pops = Dict{String,NeuronPopulation}()
        weights = Dict{Tuple{String,String},AbstractArray}()
        new(pops, weights)
    end
end

function spike_after_delay(pop::NeuronPopulation)
    spike = spzeros(Float32, length(pop.delays))
    for i = 1:length(pop.delays)
        # This will automatically skip storing zeros
        spike[i] = pop.spike[i, pop.delays[i]]
    end

    return spike
end

function sim_step!(pop::NeuronPopulation, spike::SparseVector{Float32,}, weights::AbstractArray)
    # update postsynaptic population given incident voltages
    pop.current += weights*spike

    ### Changes in each time step
    dvoltage = ((reset_voltage_V .- pop.voltage ) / time_constant_memb_τ) .+ (pop.current / membrane_capacitance_C) #Specify change in voltage
    dcurrent = -pop.current / time_constant_syn_τ #Specify change in I_syn

    # calculate v_out
    # v_out = voltage + dV??
    pop.voltage .+= dvoltage * pop.dt
    pop.current .+= dcurrent * pop.dt
end

function activation!(pop::NeuronPopulation)
    n = length(pop.voltage)

    for i = 1:n
        if sum(pop.spike[i, 0.0:pop.dt:refractory_time_t]) == 0.0f0 && pop.voltage[i] > threshold_θ
            pop.spike[i] = 1.0f0
            pop.voltage[i] = reset_voltage_V
        end
    end
end

function sim_step!(pop_post::NeuronPopulation, pop_pre::NeuronPopulation, weights::AbstractArray)
    spike = spike_after_delay(pop_pre)  # todo: don't recompute this for every pop_pre

    sim_step!(pop_post, spike, weights)
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

                sim_step!(pop_post, pop_pre, weights)
            end
        end

        activation!(pop_post)

        new_pops[pop_post_key] = pop_post

    end

    net.pops = new_pops
end
