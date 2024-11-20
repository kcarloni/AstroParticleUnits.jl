module AstroParticleUnits

using NaturallyUnitful: natural, unnatural, uconvert
using UnitfulAstro
using Unitful: @u_str, @unit, unit, Quantity, ustrip, NoDims
using Unitful: uparse, prefix, abbr, power

using Corpuscles 

export @u_str, ustrip, natural, uconvert, unit

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

const MeV = u"MeV"
const GeV = u"GeV"
const TeV = u"TeV"
const PeV = u"PeV"
const EeV = u"EeV"

const kpc = u"kpc"

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
    :pc, :kpc, #:AU, :ly, 
    :MeV, :GeV, :TeV, :PeV, :EeV,
    :cm, 
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

Base.:*( 
    num::Quantity{T1, D, U}, 
    denom::Quantity{T2, D, U}) where {T1, T2, U, D} = 
        num.val * denom.val * unit(num) * unit(denom)
    
Base.:*( 
    num::Quantity{T1, D, U1}, 
    denom::Quantity{T2, D, U2}) where {T1, T2, U1, U2, D} = 
        uconvert(unit(denom), num) * denom


"""
    parse_unit_to_recoverable_obj(u)

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



end # module AstroParticleUnits
