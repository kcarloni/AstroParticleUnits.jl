

Unit utility is derived from:

`Unitful.jl`
`NaturallyUnitful.jl`
`UnitfulAstro.jl`
`PhysicalConstants.jl`
`Corpuscles.jl`

The following units are exported:

```julia
units_to_export = (
    :c, :ħ, :α,
    :m, :s, :eV,
    :rad, :°, :sr,
    :c0, #:q, 
    :pc, #:AU, :ly, 
    :MeV, :GeV, :TeV, :PeV, :EeV,
    :kpc, :cm, 
    :mb,
    :Gauss, :μG,
    :Msun,
    :m_proton, :m_electron
)
```

Additionally, I modified `Base.:/` to cancel units automatically when dividing two quantities, e.g.:

```julia

julia> c / (1m/s)
2.99792458e8

```



