module AstroParticleUnits

using Unitful
using UnitfulAstro

using NaturallyUnitful: natural, unnatural, uconvert
using Unitful: @unit, prefix, abbr, power
using Unitful: @u_str, unit, Quantity, ustrip, NoDims, FreeUnits
using Unitful: uparse
# import Unitful: uparse

using Corpuscles 

using LaTeXStrings: @L_str
import LaTeXStrings: latexstring 

export @u_str, unit, Quantity, ustrip, NoDims, uparse, FreeUnits
export natural, unnatural, uconvert
export prefix, abbr, power

# import units: 

unitful_to_import = (
    :m, :s, :eV,
    :c0, :q, :ħ,
    :yr,
    :b,
    :Gauss, 
    :rad, :°, :sr 
)
for u in unitful_to_import
    @eval import Unitful: $u
end

import UnitfulAstro: AU, ly, pc, Msun
import NaturallyUnitful: c, ħ
import PhysicalConstants.CODATA2018: α


# additionally useful constants:

const cm = u"cm"
const km = u"km"

const MeV = u"MeV"
const GeV = u"GeV"
const TeV = u"TeV"
const PeV = u"PeV"
const EeV = u"EeV"

const kpc = u"kpc"
const Mpc = u"Mpc"
const Gpc = u"Gpc"

const mb = u"mb"
# const μb = u"μb"

const μG = u"μGauss"

const m_proton = Particle("proton").mass.value * c^2
const m_electron = Particle("electron").mass.value * c^2



# export units: 
units_to_export = (
    :c, :ħ, :α,
    :m, :s, :eV,
    :rad, :°, :sr,
    :c0, #:q, 
    :pc, :kpc, :Mpc, :Gpc,
    #:AU, :ly, 
    :MeV, :GeV, :TeV, :PeV, :EeV,
    :cm, :km,
    :mb,
    :Gauss, :μG,
    :Msun,
    :m_proton, :m_electron
)
for x in units_to_export
    @eval export $x
end



# convenience: unit canceling in division / multiplication

Base.:/( num::Quantity{T1, D, U}, denom::Quantity{T2, D, U}) where {T1, T2, U, D} = num.val / denom.val
Base.:/( num::Quantity{T1, D, U1}, denom::Quantity{T2, D, U2}) where {T1, T2, U1, U2, D} = uconvert(unit(denom), num) / denom

# Base.:*( 
#     num::Quantity{T1, D, U}, 
#     denom::Quantity{T2, D, U}) where {T1, T2, U, D} = 
#         num.val * denom.val * unit(num) * unit(denom)
    
# Base.:*( 
#     num::Quantity{T1, D, U1}, 
#     denom::Quantity{T2, D, U2}) where {T1, T2, U1, U2, D} = 
#         uconvert(unit(denom), num) * denom


# use UnitfulParsableString.jl instead (?)
"""
    get_parseable_string_for_unit(u)

unlike string(u), returns a string that can be parsed by `uparse`. 
"""
function get_parseable_string_for_unit(u)

    if typeof(u).parameters[1] == ()
        return ""
    end

    utup = [(
        abbr = prefix(ui)*abbr(ui),
        pow = power(ui)
    ) for ui in typeof(u).parameters[1]]

    prod([
        string(ui.abbr)*"^("*string(ui.pow)*") * " for ui in utup
    ])[1:end-3]
end
export get_parseable_string_for_unit

function latexstring( u::FreeUnits )

    utup = [(
        abbr = prefix(ui)*abbr(ui),
        pow = power(ui)
    ) for ui in typeof(u).parameters[1]]

    return latexstring(
        prod( L"\textrm{%$(ui.abbr)}^{%$( ui.pow.den == 1 ? Int(ui.pow) : Float64(ui.pow) )}" for ui in utup )
    )
end



const AstroParticle_base_unit_context = [ Unitful, UnitfulAstro ]

# """
#     uparse(string)

# Re-exported by AstroParticleUnits from Unitful with a default
#     `unit_context = AstroParticle_base_unit_context`.

# Outputs of `get_parseable_string_for_unit` are parseable. 
# """
# uparse( str ) = uparse( str; unit_context=AstroParticle_base_unit_context )
# __precompile__(false)

unitparse( str ) = uparse( str; unit_context=AstroParticle_base_unit_context )
export unitparse

macro uconvert(u, x)
    return quote
        uconvert.( $(esc(u)), $(esc(x)) )
    end
end
export @uconvert

end # module AstroParticleUnits
