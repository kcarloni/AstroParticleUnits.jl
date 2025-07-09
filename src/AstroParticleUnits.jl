module AstroParticleUnits

using Unitful
using UnitfulAstro

using NaturallyUnitful: natural, unnatural, uconvert
using Unitful: @unit, prefix, abbr, power
using Unitful: @u_str, unit, Quantity, ustrip, NoDims, FreeUnits
using Unitful: uparse

# for particle properties 
using Corpuscles 

using UnitfulParsableString

using LaTeXStrings: @L_str
import LaTeXStrings: latexstring 

export @u_str, unit, Quantity, ustrip, NoDims, uparse, FreeUnits
export natural, unnatural, uconvert
export prefix, abbr, power

# ===================
# fix the default unit context 

const AstroParticle_unit_context = [ Unitful, UnitfulAstro ]
function __init__()
    uparse( str ) = uparse( str; unit_context=AstroParticle_unit_context )
end

# ===================
# setup units

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
    import UnitfulAstro: AU, ly, pc, Msun, Rsun
    import NaturallyUnitful: c, ħ
    import PhysicalConstants: CODATA2022.α

    units_to_export = [
        :c, :ħ, :α,
        :m, :s, :eV,
        :rad, :°, :sr,
        :c0, 
        #:q, 
        # :ly, 
        :AU, :pc, 
        :Msun, :Rsun
    ]

    # additionally useful constants:
    const cm = u"cm"
    const km = u"km"
    append!( units_to_export, [:cm, :km] )

    const MeV = u"MeV"
    const GeV = u"GeV"
    const TeV = u"TeV"
    const PeV = u"PeV"
    const EeV = u"EeV"
    append!( units_to_export, [:MeV, :GeV, :TeV, :PeV, :EeV] )

    const kpc = u"kpc"
    const Mpc = u"Mpc"
    const Gpc = u"Gpc"
    append!( units_to_export, [:kpc, :Mpc, :Gpc] )

    const mb = u"mb"
    # const μb = u"μb"
    const μG = u"μGauss"
    append!( units_to_export, [:mb, :μG, :Gauss] )

    const q_electron = u"q"
    const m_proton = Particle("proton").mass.value * c^2
    const m_electron = Particle("electron").mass.value * c^2
    append!( units_to_export, [:m_proton, :m_electron, :q_electron] )

    const m_pi0 = Particle("pi0").mass.value * c^2
    const m_muon = Particle("muon").mass.value * c^2 
    const m_tau = Particle("tau").mass.value * c^2
    append!( units_to_export, [:m_pi0, :m_muon] )

    # const m_Wboson = Particle("W+").mass.value * c^2
    # const m_Zboson = Particle("Z0").mass.value * c^2
    # sin_sq_θW = 1 - (m_Wboson / m_Zboson)^2

    # CODATA 2022
    const sin_sq_θW = 0.22305
    push!( units_to_export, :sin_sq_θW )

    # natural units
    const G_fermi = 1.1663787e-5 * GeV^(-2)
    push!( units_to_export, :G_fermi )

    # const ϵ0 = u"ϵ0"
    # const kg = u"kg"
    # const g_earth = u"ge"
    # const N = u"N"
    # const C = u"C"
    # export ϵ0, kg, ge, N, C

    for x in units_to_export
        @eval export $x
    end

#

# ===================
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

#

# =============================
# latex + show

    function latexstring( u::FreeUnits )

        utup = [(
            abbr = prefix(ui)*abbr(ui),
            pow = power(ui)
        ) for ui in typeof(u).parameters[1]]

        return latexstring( prod(
            ( ui.pow == 1 ) ? L"\mathrm{%$(ui.abbr)}" : L"\mathrm{%$(ui.abbr)}^{%$( ui.pow.den == 1 ? ui.pow.num : Float64(ui.pow) )}"
            # prod( L"\mathrm{%$(ui.abbr)}^{%$( format_pow(ui.pow) )}" 
            for ui in utup )
        )
    end
 
    Base.typeinfo_prefix( io::IO, v::AbstractVector{T} ) where {T <: Quantity} = "", false
#

macro uconvert(u, x)
    return quote
        uconvert.( $(esc(u)), $(esc(x)) )
    end
end
export @uconvert

end # module AstroParticleUnits
