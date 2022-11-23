#using Unitful 

import Base.getindex
import Base.setindex!

mutable struct TemporalBuffer{T}
    dt   # Smallest time interval
    buf::AbstractArray{T,2}
end

function time_length(tb::TemporalBuffer{T}) where {T}
	return tb.dt*(size(tb.buf,2)-1)
end 

function advance!(tb::TemporalBuffer{T}) where {T}
    nr, nc = size(tb.buf)
    tb.buf = hcat(zeros(T, nr), tb.buf[:, 1:nc-1])
end

function getindex(tb::TemporalBuffer{T}, i, t) where {T}
    j = round(Int, floor(t / tb.dt))
    return tb.buf[i, j+1]
end

# Implicitly assumes time=0
function getindex(tb::TemporalBuffer{T}, i) where {T}
    return tb.buf[i, 1]
end

function getindex(tb::TemporalBuffer{T}, i, tr::StepRangeLen) where {T}
    if tr.offset != 1
        # TODO
        throw(ArgumentError(""))
    end 

    if !isapprox(tb.dt, tr.step)
        # TODO
        throw(ArgumentError(""))
    end 

    ref = round(Int, floor(tr.ref / tb.dt))
    return tb.buf[i, (ref+1):(ref+tr.len)]
end


# implicitly assumes time=0)
function setindex!(tb::TemporalBuffer{T}, x, i) where {T}
    tb.buf[i, 1] = x
end

function Base.copy(tb::TemporalBuffer{T}) where {T}
    return TemporalBuffer(tb.dt, copy(tb.buf))
end
