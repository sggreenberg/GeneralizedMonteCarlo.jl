using GeneralizedMonteCarlo
using Test, Distributions, Symbolics
@testset "inputPassthrough" begin
    @testset "PMF input" begin
        @test issubset(GeneralizedMonteCarlo.inputPassthrough([.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .05]), [.01, .02, .03, .04, .05, .08])
        @test isa(GeneralizedMonteCarlo.inputPassthrough([.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .05]), Float64)
        @test_throws ArgumentError GeneralizedMonteCarlo.inputPassthrough([.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .05; 1 2 3 4 5 6])
        @test_throws ArgumentError GeneralizedMonteCarlo.inputPassthrough([.01 .02 .03 .04 .05 .08; .1 .2 .3 .25 .10 .15])
    end
    @testset "Sampleable input" begin
        @test 0 ≤ GeneralizedMonteCarlo.inputPassthrough(Distributions.Uniform(0, 1)) ≤ 1
        @test isa(GeneralizedMonteCarlo.inputPassthrough(Distributions.Uniform(0, 1)), Float64)
    end
    @testset "Real number input" begin
        @test GeneralizedMonteCarlo.inputPassthrough(0) == 0.0
        @test isa(GeneralizedMonteCarlo.inputPassthrough(0), Float64)
    end
end

@testset "GMC" begin
    @test begin @variables iws ms p; GeneralizedMonteCarlo.GMC(10_000, [iws, ms, 190 + ms + p], [iws, ms, p], [[10_000_000 10_500_000 11_000_000; 0.2 0.6 0.2], [0.01 0.02 0.03 0.04 0.05 0.08; 0.10 0.20 0.30 0.25 0.10 0.05], [-3.0 3.0; 0.5 0.5]])[1] isa Array end
end
