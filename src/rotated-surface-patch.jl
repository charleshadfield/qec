export RotatedSurfacePatch, buildsymplecticrepn, measurestabilizers!

# rotated surface patch without ancillas.

# establish code qubits on edges
# implement plaquette/star stabilizer measurements

# define d to be width=height of surface patch.
# define n to be number of qubits n = d^2

# rotated surface patch guaranteed to protect at least floor(d-1/2) errors

struct RotatedSurfacePatch
    d::Int
    n::Int
end

RotatedSurfacePatch(d) = RotatedSurfacePatch(d, d^2)

function buildsymplecticrepn(rsp::RotatedSurfacePatch)
    vqc = VirtualQuantumComputer.VQC(rsp.n)
    VirtualQuantumComputer.buildsymplecticrepn(vqc)
end

# rsp = RotatedSurfacePatch(3)
# n = 9
# vqc = VQC(9)
# symp = buildsymplecticrepn(vqc)
# qubits are numbered
#
#  1 4 7
#  2 5 8
#  3 6 9
#
# if we add in the stabilizers:
#
#      X
#   1 4 7
#  Z X Z
#   2 5 8
#    Z X Z
#   3 6 9
#    X

# find leading corners for stabilizers of weight 4
function _leadingcorners4(rsp::RotatedSurfacePatch, P::Char)
    d = rsp.d
    n = rsp.n

    leadingcorners = [k for k=1:n]
    filter!( k -> k ≤ n-d, leadingcorners)
    filter!( k -> (k % d) != 0, leadingcorners)

    P == 'X' && filter!( k -> k % 2 == 1, leadingcorners)
    P == 'Z' && filter!( k -> k % 2 == 0, leadingcorners)

    leadingcorners
end
# find leading corners for stabilizers of weight 2
function _leadingcorners2(rsp::RotatedSurfacePatch, P::Char)
    d = rsp.d
    n = rsp.n

    leadingcorners::Vector{Int} = []

    if P == 'X'
        for k = d:2d:d*(d-2)
            push!(leadingcorners, k, k+1)
        end
    end

    if P == 'Z'
        for k = 1:2:d-2
            push!(leadingcorners, k)
        end
        for k = d*(d-1)+2:2:n-1
            push!(leadingcorners, k)
        end
    end

    leadingcorners
end
function leadingcorners(rsp::RotatedSurfacePatch, P::Char, weight::Int)
    @assert P in ['X', 'Z']
    @assert weight in [2, 4]

    weight == 2 ? (f=_leadingcorners2) : (f=_leadingcorners4)

    f(rsp, P)
end

# find qubits for stabilizer associated with leading corner
function stabilizerqubits(rsp::RotatedSurfacePatch, P::Char, weight::Int, leadingcorner::Int)
    n = rsp.n
    d = rsp.d

    @assert P in ['X', 'Z']
    @assert weight in [2, 4]

    lc = leadingcorner
    @assert 1 ≤ lc ≤ n
    @assert lc in leadingcorners(rsp, P, weight)

    stab::Vector{Int} = []

    if weight == 4
        push!(stab, lc, lc+1, lc+d, lc+d+1)
    else
        if P == 'X'
            push!(stab, lc, lc+d)
        elseif P == 'Z'
            push!(stab, lc, lc+1)
        end
    end

    stab
end

function measurestabilizers!(symp, rsp::RotatedSurfacePatch, P::Char)
    @assert P in ['X', 'Z']
    syndromeP4::Vector{Int} = []
    syndromeP2::Vector{Int} = []
    for weight in [2, 4]
        for lc in leadingcorners(rsp, P, weight)
            qubits = stabilizerqubits(rsp, P, weight, lc)
            m = VirtualQuantumComputer.measureclifford!(symp, P^weight, qubits)
            weight == 2 ? push!(syndromeP2, m) : push!(syndromeP4, m)
        end
    end
    syndromeP4, syndromeP2
end
