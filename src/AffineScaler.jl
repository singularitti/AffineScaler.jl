module AffineScaler

using StructEquality: @struct_hash_equal_isequal_isapprox

export Scaler, rescale_zero_one, rescale_one_zero

"""
    Scaler(k, b)

Create a linear transformation `y = k x + b`.

Throw an `ArgumentError` if `k` is zero.

# Examples
```jldoctest
julia> Scaler(2.0, 1)
y = 2.0 x + 1

julia> Scaler(-1, 1.4)
y = -x + 1.4

julia> Scaler(1.0, 2)
y = x + 2

julia> Scaler(1, 2)
y = x + 2

julia> Scaler(1, 2).(1:4)
4-element Vector{Int64}:
 3
 4
 5
 6

julia> Scaler(1, 2)(I)
UniformScaling{Int64}
3*I
```
"""
@struct_hash_equal_isequal_isapprox struct Scaler{K,B}
    k::K
    b::B
    function Scaler(k::K, b::B) where {K,B}
        if iszero(k)
            throw(ArgumentError("The slope `k` must be non-zero!"))
        end
        return new{K,B}(k, b)
    end
end

"Transform an input `x` (scalars or matrices) using the linear formula `y = k * x + b * oneunit(x)`."
(s::Scaler)(x) = s.k * x + s.b * oneunit(x)

"""
    inv(s::Scaler)

Compute the inverse of a linear transformation.

# Examples
```jldoctest
julia> s = Scaler(2.0, 1.0)
y = 2.0 x + 1.0

julia> inv(s)
y = 0.5 x - 0.5

julia> inv(inv(s)) == s
true
```
"""
Base.inv(s::Scaler) = Scaler(inv(s.k), -s.b / s.k)

"""
    rescale_zero_one(𝐱)
    rescale_zero_one(x...)

Map the minimum of `𝐱` to `0` and the maximum to `1`.

# Examples
```jldoctest
julia> 𝐱 = [2.0, 4.0, 6.0];

julia> s = rescale_zero_one(𝐱)
y = 0.25 x - 0.5

julia> s.(𝐱)
3-element Vector{Float64}:
 0.0
 0.5
 1.0
```
"""
function rescale_zero_one(𝐱)  # Map `max` to 1, `min` to 0
    min, max = extrema(𝐱)
    @assert min < max
    k, b = inv(max - min), min / (min - max)
    return Scaler(k, b)
end
rescale_zero_one(𝐱...) = rescale_zero_one(𝐱)

"""
    rescale_one_zero(𝐱)
    rescale_one_zero(x...)

Map the minimum of `𝐱` to `1` and the maximum to `0`.

# Examples
```jldoctest
julia> 𝐱 = [2.0, 4.0, 6.0];

julia> s = rescale_one_zero(𝐱)
y = -0.25 x + 1.5

julia> s.(𝐱)
3-element Vector{Float64}:
 1.0
 0.5
 0.0
```
"""
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
