module Assets

using Instruments, FixedPointDecimals
import Instruments: Position, currency, symbol, unit, code, name

export Currencies, Currency, Position, Cash, FixedDecimal

"""
`Cash` is a financial instrument represented by a singleton type with its currency symbol and the number of digits in the minor units, typically 0, 2, or 3, as parameters.
"""
struct Cash{S, N} <: AbstractInstrument{S,Currency{S}} end
Cash(S::Symbol) = Cash{S,unit(S)}()
Cash(::Currency{S}) where {S} = Cash(S)

unit(::Cash{C,N}) where {C,N} = N
code(c::Cash) = code(currency(c))
name(c::Cash) = name(currency(c))

Base.show(io::IO, ::Cash{<:Currency{T}}) where {T} = print(io, string(T))

function Position(cash::Cash{C,N}, a) where {C,N}
    T = FixedDecimal{Int,N}
    Position{Cash{C,N},T}(cash,T(a))
end

# Set up short names for all of the currencies (as instances of the Cash instruments)
for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = Cash($ccy)
end

end # module
