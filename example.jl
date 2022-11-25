using Pkg 
Pkg.develop(path="./Simulator")
Pkg.develop(path="./NetworkDefinition")

using NetworkDefinition
using Simulator 
using Statistics
using Plots

net = create_default_network()

# Give population 2/3E a set of inputs with synaptic current 80.0 pA,
# and collective firing rate of 8 Hz x 2000 synapses
inputs = Dict("2/3E" => (87.8, 8f0*2000), "2/3I" => (87.8, 8f0*1850),
              "4E" => (87.8, 8f0*2000), "4I" => (87.8, 8f0*1850), 
              "5E" => (87.8, 8f0*2000), "5I" => (87.8, 8f0*1850),
              "6E" => (87.8, 8f0*2000), "6I" => (87.8, 8f0*1850))

sim_time = 0.25 #seconds
timesteps = round(Int, sim_time/1e-4)
spike_array_23E = zeros(Float32, length(net.pops["2/3E"].current), timesteps)
spike_array_23I = zeros(Float32, length(net.pops["2/3I"].current), timesteps)
spike_array_4E = zeros(Float32, length(net.pops["4E"].current), timesteps)
spike_array_4I = zeros(Float32, length(net.pops["4I"].current), timesteps)
voltage_array_5E = zeros(Float32, length(net.pops["5E"].current), timesteps)
spike_array_5E = zeros(Float32, length(net.pops["5E"].current), timesteps)
spike_array_5I = zeros(Float32, length(net.pops["5I"].current), timesteps)
spike_array_6E = zeros(Float32, length(net.pops["6E"].current), timesteps)
spike_array_6I = zeros(Float32, length(net.pops["6I"].current), timesteps)

for i in 1:timesteps       
    sim_step!(net, inputs)
    spike_array_23E[:, i] = net.pops["2/3E"].spike.buf[:, 1]
    spike_array_23I[:, i] = net.pops["2/3I"].spike.buf[:, 1]
    spike_array_4E[:, i] = net.pops["4E"].spike.buf[:, 1]
    spike_array_4I[:, i] = net.pops["4I"].spike.buf[:, 1]
    voltage_array_5E[:, i] = net.pops["5E"].voltage
    spike_array_5E[:, i] = net.pops["5E"].spike.buf[:, 1]
    spike_array_5I[:, i] = net.pops["5I"].spike.buf[:, 1]
    spike_array_6E[:, i] = net.pops["6E"].spike.buf[:, 1]
    spike_array_6I[:, i] = net.pops["6I"].spike.buf[:, 1]
end

#@show spike_array
sum_spike_23E = sum(spike_array_23E[:, 500:end], dims=1)
println(sum(sum_spike_23E))
sum_spike_23I = sum(spike_array_23I[:, 500:end], dims=1)
println(sum(sum_spike_23I))
sum_spike_4E = sum(spike_array_4E[:, 500:end], dims=1)
println(sum(sum_spike_4E))
sum_spike_4I = sum(spike_array_4I[:, 500:end], dims=1)
println(sum(sum_spike_5I))
sum_spike_5E = sum(spike_array_5E[:, 500:end], dims=1)
println(sum(sum_spike_5E))
sum_spike_5I = sum(spike_array_5I[:, 500:end], dims=1)
println(sum(sum_spike_5I))
sum_spike_6E = sum(spike_array_6E[:, 500:end], dims=1)
println(sum(sum_spike_6E))
sum_spike_6I = sum(spike_array_6I[:, 500:end], dims=1)
println(sum(sum_spike_6I))

mean_spike_23E = Statistics.mean(sum_spike_23E)
println(mean_spike_23E)
mean_spike_23I = Statistics.mean(sum_spike_23I)
println(mean_spike_23I)
mean_spike_4E = Statistics.mean(sum_spike_4E)
println(mean_spike_4E)
mean_spike_4I = Statistics.mean(sum_spike_4I)
println(mean_spike_4I)
mean_spike_5E = Statistics.mean(sum_spike_5E)
println(mean_spike_5E)
mean_spike_5I = Statistics.mean(sum_spike_5I)
println(mean_spike_5I)
mean_spike_6E = Statistics.mean(sum_spike_6E)
println(mean_spike_6E)
mean_spike_6I = Statistics.mean(sum_spike_6I)
println(mean_spike_6I)

a = plot(sum_spike_23E[1, :])
#a = plot(current_array[20, :])
#c = plot(spike_array[20, :])
@show a
