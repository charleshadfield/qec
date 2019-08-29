import VirtualQuantumComputer

# this is really a test for the VirtualQuantumComputer module
# distance 2 non-rotated surface patch.

@testset "distance 2 surface patch" begin

n = 5
vqc = VirtualQuantumComputer.VQC(n)
symp = VirtualQuantumComputer.buildsymplecticrepn(vqc)

a = VirtualQuantumComputer.measureclifford!(symp, "ZZZ", [1,2,3])
b = VirtualQuantumComputer.measureclifford!(symp, "ZZZ", [3,4,5])
c = VirtualQuantumComputer.measureclifford!(symp, "XXX", [1,3,4])
d = VirtualQuantumComputer.measureclifford!(symp, "XXX", [2,3,5])

firstmeasurements = [a, b, c, d]

a = VirtualQuantumComputer.measureclifford!(symp, "ZZZ", [1,2,3])
b = VirtualQuantumComputer.measureclifford!(symp, "ZZZ", [3,4,5])
c = VirtualQuantumComputer.measureclifford!(symp, "XXX", [1,3,4])
d = VirtualQuantumComputer.measureclifford!(symp, "XXX", [2,3,5])

secondmeasurements = [a, b, c, d]

@test firstmeasurements[1:2] == [0, 0]

@test firstmeasurements == secondmeasurements

@test symp == VirtualQuantumComputer.rref!(symp)

groundstate = [1 0 0 1 0   0 0 0 0 0   0;
               1 1 1 0 0   0 0 0 0 0   0;
               0 0 1 1 1   0 0 0 0 0   0;
               0 0 0 0 0   1 0 1 1 0   0;
               0 0 0 0 0   0 1 1 0 1   0]

VirtualQuantumComputer.rref!(groundstate)

@test symp[:,1:end-1] == groundstate[:,1:end-1]

end # @testset
