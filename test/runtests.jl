using AffineScaler
using Test

@testset "AffineScaler.jl" begin
    @testset "Test `rescale_zero_one`" begin
        𝐱 = 1:5
        X = [1.0 2.0; 3.0 4.0]
        rescaler = rescale_zero_one(𝐱)
        @test inv(inv(rescaler)) == rescaler
        @testset "Test number rescaling" begin
            @test rescaler(1.0) == 0
            @test rescaler(5.0) == 1
            @test rescaler(2) == 1 / 4
            @test rescaler(3.0) == 1 / 2
            @test rescaler(4) == 3 / 4
        end
        @testset "Test number rescaling" begin
            @test rescaler(X) == [
                0 1/2
                3/4 3/4
            ]
        end
        @test_throws AssertionError rescale_zero_one(3, 3.0)
    end

    @testset "Test `rescale_one_zero`" begin
        𝐱 = 5:-1:1
        X = [1.0 2.0; 3.0 4.0]
        rescaler = rescale_one_zero(𝐱)
        @test inv(inv(rescaler)) == rescaler
        @testset "Test number rescaling" begin
            @test rescaler(1.0) == 1
            @test rescaler(5.0) == 0
            @test rescaler(4) == 1 / 4
            @test rescaler(3.0) == 1 / 2
            @test rescaler(2) == 3 / 4
        end
        @testset "Test matrix rescaling" begin
            @test rescaler(X) == [
                1 -1/2
                -3/4 1/4
            ]
        end
        @test_throws AssertionError rescale_one_zero(3, 3.0)
    end
end
