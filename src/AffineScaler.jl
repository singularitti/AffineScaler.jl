module AffineScaler

export Scaler, rescale_zero_one, rescale_one_zero

struct Scaler{K,B}
    k::K
    b::B
    function Scaler(k::K, b::B) where {K,B}
        if iszero(k)
            throw(ArgumentError("The slope `k` must be non-zero!"))
        end
        return new{K,B}(k, b)
    end
end

(s::Scaler)(x) = s.k * x + s.b * oneunit(x)

Base.inv(r::Scaler) = Scaler(inv(r.k), -r.b / r.k)

function rescale_zero_one(𝐱)  # Map `max` to 1, `min` to 0
    min, max = extrema(𝐱)
    @assert min < max
    k, b = inv(max - min), min / (min - max)
    return Scaler(k, b)
end
rescale_zero_one(𝐱...) = rescale_zero_one(𝐱)

function rescale_one_zero(𝐱)  # Map `max` to 0, `min` to 1
    min, max = extrema(𝐱)
    @assert min < max
    k, b = inv(min - max), max / (max - min)
    return Scaler(k, b)
end
rescale_one_zero(𝐱...) = rescale_one_zero(𝐱)

function Base.show(io::IO, ::MIME"text/plain", s::Scaler)
    k, b = s.k, s.b
    if isone(k)
        k = ""
    elseif isone(-k)
        k = "-"
    else
        k = "$k "
    end
    if b < zero(b)
        print(io, "y = $(k)x - $(abs(b))")
    else
        print(io, "y = $(k)x + $b")
    end
    return nothing
end

end
