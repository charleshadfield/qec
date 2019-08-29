using QuantumErrorCorrection, Test

@testset "trivial" begin
    @test true
end

include("distance-2-surface-patch.jl")

include("test-rsp.jl")
