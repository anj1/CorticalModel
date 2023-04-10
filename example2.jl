
using Pkg 
Pkg.develop(path="./Simulator")
Pkg.develop(path="./NetworkDefinition")

using NetworkDefinition
using Simulator 
using SparseArrays
using Statistics
using Plots

net = create_default_network("Random")

# Give population 2/3E a set of inputs with synaptic current 80.0 pA,
# and collective firing rate of 8 Hz x 2000 synapses
spontaneous_inputs = Dict("2/3E" => (87.8, 8f0*2000), "2/3I" => (87.8, 8f0*1850),
              "4E" => (87.8, 8f0*2000), "4I" => (87.8, 8f0*1850), 
              "5E" => (87.8, 8f0*2000), "5I" => (87.8, 8f0*1850),
              "6E" => (87.8, 8f0*2000), "6I" => (87.8, 8f0*1850))

stimulation_inputs = Dict("2/3E" => (11.31e6, 1f0*1000), "2/3I" => (11.31e6, 1f0*1000),
              "4E" => (10.47e6, 1f0*1000), "4I" => (10.47e6, 1f0*1000), 
              "5E" => (9.61e6, 1f0*1000), "5I" => (9.61e6, 1f0*1000),
              "6E" => (8.45e6, 1f0*1000), "6I" => (8.45e6, 1f0*1000))

pop_names = keys(net.pops)

sim_time = 0.25 #seconds
timesteps = round(Int, sim_time/1e-4)

spike_array = Dict(key => spzeros(Float32, length(net.pops[key].current), timesteps) for key in pop_names)
voltage_array = Dict(key => zeros(Float32, length(net.pops[key].current), timesteps) for key in pop_names)

for i in 1:timesteps
    if i == 1000
        sim_step!(net, stimulation_inputs)
    else
    	sim_step!(net, spontaneous_inputs)
    end
    
    for key in pop_names
        spike_array[key][:, i] = net.pops[key].spike[:]
        voltage_array[key][:, i] = net.pops[key].voltage
    end 
end

#@show spike_array
sum_spike = Dict(key => sum(spike_array[key][:, 500:end], dims=1) for key in pop_names)

sum_spike_epoch = Dict(key => sum(sum_spike[key]) for key in pop_names)
mean_spike_epoch = Dict(key => Statistics.mean(sum_spike[key]) for key in pop_names)

@show sum_spike_epoch
@show mean_spike_epoch

output=sum_spike["5E"][1, :]

a = plot(output)
#a = plot(current_array[20, :])
#c = plot(spike_array[20, :])
#a = histogram(freq_array)
#println("Mean:", Statistics.mean(freq_array))
@show a
