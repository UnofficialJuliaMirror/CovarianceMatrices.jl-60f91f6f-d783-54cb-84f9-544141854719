const WFLOAT = Sys.WORD_SIZE == 64 ? Float64 : Float32



#=========
Abstraction
==========#

abstract type RobustVariance <: CovarianceEstimator end
abstract type HAC{G} <: RobustVariance end
abstract type HC <: RobustVariance end
abstract type CRHC{V} <: RobustVariance end


#=========
HAC Types
=========#

abstract type BandwidthType{G} end
abstract type OptimalBandwidth end

struct NeweyWest<:OptimalBandwidth end
struct Andrews<:OptimalBandwidth end

struct Fixed<:BandwidthType{G where G} end
struct Optimal{G<:OptimalBandwidth}<:BandwidthType{G where G<:OptimalBandwidth} end

struct Prewhitened end
struct Unwhitened end

struct TruncatedKernel{G<:BandwidthType, F}<:HAC{G}
  bwtype::G
  bw::Vector{F}
  weights::Vector{F}
  prewhiten::Bool
end

struct BartlettKernel{G<:BandwidthType, F}<:HAC{G}
    bwtype::G
    bw::Vector{F}
    weights::Vector{F}
    prewhiten::Bool
end

struct ParzenKernel{G<:BandwidthType, F}<:HAC{G}
    bwtype::G
    bw::Vector{F}
    weights::Vector{F}
    prewhiten::Bool
end

struct TukeyHanningKernel{G<:BandwidthType, F}<:HAC{G}
    bwtype::G
    bw::Vector{F}
    weights::Vector{F}
    prewhiten::Bool
end

struct QuadraticSpectralKernel{G<:BandwidthType, F}<:HAC{G}
    bwtype::G
    bw::Vector{F}
    weights::Vector{F}
    prewhiten::Bool
end


const TRK=TruncatedKernel
const BTK=BartlettKernel
const PRK=ParzenKernel
const THK=TukeyHanningKernel
const QSK=QuadraticSpectralKernel


#=========
HC Types
=========#
struct HC0  <: HC end
struct HC1  <: HC end
struct HC2  <: HC end
struct HC3  <: HC end
struct HC4  <: HC end
struct HC4m <: HC end
struct HC5  <: HC end

#const CLVector{T<:Integer} = DenseArray{T,1}

mutable struct CRHC0{V<:AbstractVector}  <: CRHC{V}
    cl::V
end

mutable struct CRHC1{V<:AbstractVector}  <: CRHC{V}
    cl::V
end

mutable struct CRHC2{V<:AbstractVector}  <: CRHC{V}
    cl::V
end

mutable struct CRHC3{V<:AbstractVector}  <: CRHC{V}
    cl::V
end

struct CovarianceMatrix{T2<:Factorization, T3<:CovarianceMatrices.RobustVariance, F1, T1<:AbstractMatrix{F1}} <: AbstractMatrix{F1}
    F::T2       ## Factorization
    K::T3       ## RobustVariance, e.g. HC0()
    V::T1       ## The Variance Covariance
end



#=======
Caches
=======#

abstract type AbstractCache end

struct HACCache{TYPE, F<:AbstractMatrix, V<:AbstractVector} <: AbstractCache
    prew::TYPE
    q::F ## Should call this q n_origin x p
    YY::F
    XX::F
    Y_lagged::F
    X_lagged::F
    μ::F        ## p x 1
    Q::F        ## p x p
    V::F        ## p x p
    D::F        ## p x p
    U::V
    ρ::V
    σ⁴::V
    u::F
end

struct CRHCCache{VN<:AbstractVector, F1<:AbstractMatrix, F2<:AbstractMatrix, V<:AbstractVector, IN<:AbstractVector} <: AbstractCache
    q::F1   
    X::F1   
    V::F2   
    v::V    
    w::V    
    η::V    
    u::V
    M::F1
    clusidx::IN
    clus::VN
end

struct HCCache{F1<:AbstractMatrix, F2<:AbstractMatrix, V1<:AbstractVector} <: AbstractCache
    q::F1  # NxM
    X::F1  # NxM
    V::F2  # pxp
    v::V1   # nx1 
    w::V1   # nx1
    η::V1   # nx1
    u::V1   # nx1
    V::F1   # mxm
end