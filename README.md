
An expanded unit handling package, designed to be a drop-in replacement for `Unitful.jl` for applications in astro-particle physics.

The following units are exported by default:
```julia
julia> println( AstroParticleUnits.units_to_export )
[:c, :ħ, :α, :m, :s, :eV, :rad, :°, :sr, :c0, :AU, :pc, :Msun, :Rsun, :cm, :km, :MeV, :GeV, :TeV, :PeV, :EeV, :kpc, :Mpc, :Gpc, :mb, :μG, :Gauss, :m_proton, :m_electron, :q_electron, :m_pi0, :m_muon, :sin_sq_θW, :G_fermi]
```

The unit utility is derived from a combination of `Unitful.jl`, `NaturallyUnitful.jl`, `UnitfulAstro.jl`, `PhysicalConstants.jl` and `Corpuscles.jl`. 

Additionally, I modified `Base.:/` to cancel units automatically when dividing two quantities, e.g.:

```julia
julia> c / (1m/s)
2.99792458e8

julia> natural(1m) / (1/eV)
5.067730716156395e6
```

`UnitfulParsableString` is used to produce parseable strings from units and quantities. `AstroParticleUnits` also exports its own function `AstroParticleUnits.uparse`, to be used as a replacement for `Unitful.uparse`, which parses all units in the correct context. 

```julia
julia> string(1GeV/s/sr/cm^2)
"1(GeV/cm^2/s/sr)"

julia> uparse( string(1GeV/s/sr/cm^2) )
1 GeV cm⁻² s⁻¹ sr⁻¹

julia> uparse( "kpc" )
kpc
```

More examples:

```julia
julia> a0 = unnatural( m, ħ / (m_electron * c * α) )
5.2917721090052e-11 m
```




