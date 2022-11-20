#using Unitful 

import Base.getindex
import Base.setindex!

mutable struct TemporalBuffer{T}
    dt   # Smallest time interval
    buf::Array{T,2}
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


# implicitly assumes time=0)
function setindex!(tb::TemporalBuffer{T}, x, i) where {T}
    tb.buf[i, 1] = x
end

function Base.copy(tb::TemporalBuffer{T}) where {T}
    return TemporalBuffer(tb.dt, copy(tb.buf))
end
