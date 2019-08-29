import VirtualQuantumComputer

@testset "rotated surface patch distance 3" begin

rsp = RotatedSurfacePatch(3)
symp = buildsymplecticrepn(rsp)

syndromeX4, syndromeX2 = measurestabilizers!(symp, rsp, 'X')
syndromeZ4, syndromeZ2 = measurestabilizers!(symp, rsp, 'Z')


syndromeX4new, syndromeX2new = measurestabilizers!(symp, rsp, 'X')
syndromeZ4new, syndromeZ2new = measurestabilizers!(symp, rsp, 'Z')

@test syndromeZ4 == [0, 0]
@test syndromeZ2 == [0, 0]

@test syndromeX4new == syndromeX4
@test syndromeX2new == syndromeX2
@test syndromeZ4new == syndromeZ4
@test syndromeZ2new == syndromeZ2

logical0 = [1 0 0 1 0 0 1 0 0   0 0 0 0 0 0 0 0 0    0; # logical0

            1 1 0 0 0 0 0 0 0   0 0 0 0 0 0 0 0 0    0; # ZZ
            0 0 0 0 0 0 0 1 1   0 0 0 0 0 0 0 0 0    0; # ZZ
            0 1 1 0 1 1 0 0 0   0 0 0 0 0 0 0 0 0    0; # ZZZZ
            0 0 0 1 1 0 1 1 0   0 0 0 0 0 0 0 0 0    0; # ZZZZ

            0 0 0 0 0 0 0 0 0   0 0 1 0 0 1 0 0 0    0; # XX
            0 0 0 0 0 0 0 0 0   0 0 0 1 0 0 1 0 0    0; # XX
            0 0 0 0 0 0 0 0 0   1 1 0 1 1 0 0 0 0    0; # XXXX
            0 0 0 0 0 0 0 0 0   0 0 0 0 1 1 0 1 1    0] # XXXX

VirtualQuantumComputer.rref!(logical0)

@test symp[:,1:end-1] == logical0[:,1:end-1]

end # @testset
