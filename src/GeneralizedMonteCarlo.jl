module GeneralizedMonteCarlo 

using Pkg, Pkg.TOML, Distributions, DocStringExtensions, Documenter, Symbolics
"""
$(SIGNATURES)

Either makes a random draw of a float from the distribution based on its specified parameters/pmf or returns the input as a float

#Example

```julia-repl
julia> issubset(GeneralizedMonteCarlo.inputPassthrough([.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .05]), [.01 .02 .03 .04 .05 .08])
true
```

```julia-repl
julia> 0 ≤ GeneralizedMonteCarlo.inputPassthrough(Uniform(0, 1)) ≤ 1
true
```

```julia-repl
julia> GeneralizedMonteCarlo.inputPassthrough(3) == 3.0
true
```

"""
function inputPassthrough(x :: Union{Real, Sampleable, Matrix{Float64}}) 
    if typeof(x) <: Matrix 
        return rand(Distributions.DiscreteNonParametric(x[1, :], vec(x[2:size(x)[1], :])))*1.0 #draws randomly from given pmf
    elseif typeof(x) <: Sampleable
        return rand(x)*1.0 
    elseif typeof(x) <: Real
        return x*1.0 
    end
end

"""
$(SIGNATURES)

Creates a new Monte Carlo simulation of calculating revenue according to a model of the users preferences, when given the number of simulations to calculate, as well as the distributions (can be user defined with a pmf or from https://github.com/JuliaStats/Distributions.jl). Or the user can just pass through a Real number. Returns array of random draws and the values from the equation.

Notice that:
julia> @variables var1 var2 ...
needs to be ran before the function, as shown in the example below.

#Example

```julia-repl
julia> @variables iws ms p; GeneralizedMonteCarlo.GMC(10_000, [iws, ms, 190 + ms + p], [iws, ms, p], [[10_000_000 10_500_000 11_000_000; 0.2 0.6 0.2], [0.01 0.02 0.03 0.04 0.05 0.08; 0.10 0.20 0.30 0.25 0.10 0.05], [-3.0 3.0; 0.5 0.5]]) 
```

"""
function GMC(NSimulations :: Int, equations :: Array, symbols :: Array, probs :: Array)
    draws = zeros(Float64, NSimulations, length(equations))
    values = zeros(Num, NSimulations, length(equations))
    floatvalues = zeros(Float64, NSimulations, length(equations))
    for n in 1:NSimulations
        for l in 1:length(equations)
            draws[n, l] = inputPassthrough(probs[l])
        end
        for l in 1:length(equations)
            values[n,l] = substitute(Num(equations[l]), Dict(zip(symbols, draws[n, :])))[1]
            floatvalues[n, l] = parse(Float64, string(values[n, l]))
        end
    end
    return floatvalues, draws
end
end
