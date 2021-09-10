# GeneralizedMonteCarlo.jl

`GeneralizedMonteCarlo.jl` is a Julia package designed to run a Monte Carlo simulation and model of multiple variables. 
As of v0.1.0 it contains two type-stable functions:

## Functions

### inputPassthrough(x :: Union{Real, Sampleable, Matrix{Float64}})

`inputPassthrough()` is a function that either draws from a given distribution - whether it be a probability mass function(written as a 2xN matrix) or a distribution (using Distributions.jl package) with given parameters - or just passes through the original (real) number (as a float). This is a vital function in the GMC function.

#### Example

julia> GeneralizedMonteCarlo.inputPassthrough(\[.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .05\])

The example above makes a randome draw from the above matrix written as a pmf 

julia> GeneralizedMonteCarlo.inputPassthrough(Uniform(0, 1))

The example above makes a random draw from the given Distributions.jl distribution with the given parameters

julia> GeneralizedMonteCarlo.inputPassthrough(3) 

This example above returns 3.0 from 3 to maintain type stability 

### GMC(NSimulations :: Int, equations :: Array, symbols :: Array, probs :: Array)

`GMC()` (which is an acronym for Generalized Monte Carlo) is a function that runs a Monte Carlo simulation and model of multiple variables.
The first input, NSimulations, is the amount of samples (Integer) to take of each of the input symbols (written as an array of symbolics defined variables); and, probs is the an array of inputs for the function inputPassthrough, used to make random draws. The input equations is an array of equations (using the symbolics defined variables) calculates values with the user-defined equations from the draws. 
Currently, all of the variables with an array input (equations, symbols, and probs) need to be of the same length. 
In addition, the symbols need to be defined before the function as well with:

julia> @variables var1 ... varN

and the macro @variables comes from the Symbolics.jl package

#### Example

julia> @variables iws ms p; GeneralizedMonteCarlo.GMC(10_000, \[iws, ms, 190 + ms + p\], \[iws, ms, p\], \[\[10_000_000 10_500_000 11_000_000; 0.2 0.6 0.2\], \[0.01 0.02 0.03 0.04 0.05 0.08; 0.10 0.20 0.30 0.25 0.10 0.05\], \[-3.0, 3.0; 0.5 0.5\]\]) 
This example above first has the prerequisite of making sure each input of symbol is defined beforehand with @variables macro from the Symbolics.jl package. The GMC function then runs 10,000 samples of each symbol (iws, ms, and p) based on the defined pmf from probs. It then calculates the result of each of the equations and returns an array of all of the results as well as well as an array of all the draws.
   
## Plans for Future Versions

The following are my plans for future versions. Write other desired features and/or which features you want the most, in the respective pinned github discussion. In addition share any advice or code you have that can help (mainly if it is type-stable). The following are my plans so far (in no particular order):

1.  Combine @variables macro and function somehow.
2.  JuliaInXL functionality