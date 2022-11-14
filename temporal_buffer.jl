using Unitful 

struct TemporalBuffer{T} where T
	dt   # Smallest time interval
	buf::Array{T, 2}
end 

function advance!(tb::TemporalBuffer{T})
	nr, nc = size(tb.buf)
	tb.buf = hcat(zeros(T, nr), tb.buf[:, 1:nc-1])
end 
	
function getindex(tb::TemporalBuffer, i, t)
	j = round(Int, floor(t/tb.dt))
	return tb.buf[i, j]
end 