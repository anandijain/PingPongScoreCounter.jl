module PingPongScoreCounter

using LsqFit

ampd(y, args...; kwargs...) = _ampd(eachindex(y), y, args...; kwargs...)
function _ampd(x, y, α::Real = 1.0; mode::Symbol=:max, full::Bool=false, λ=nothing)
    #Linearly detrend - fit to straight line and subtract it
    model(x, p) = p[1].*x .+ p[2]
    fit = curve_fit(model, x, y, zeros(2))
    p = fit.param
    y -= x.*p[1] .+ p[2]

    #Computing local maxima scalogram
    N = length(y)
    L = λ===nothing ? (cld(N, 2)-1) : λ
    M = α .+ rand(L, N)
    for k=1:L #Scale of signal
        for i=k+2:N-k+1
            if mode == :max
                (y[i-1] > y[i-k-1] && y[i-1] > y[i+k-1]) && (M[k, i] = 0)
            elseif mode == :min
                (y[i-1] < y[i-k-1] && y[i-1] < y[i+k-1]) && (M[k, i] = 0)
            end
        end
    end

    #Compute row-wise summation
    γ = sum(M, 2)
    λ===nothing && ((_, λ) = findmin(γ))

    #Detect peaks
    σ = map(i->std(sub(M, 1:λ, i)), 3:N)

    z = find(iszero, σ) .+ 1
    
    full ? (z, M, σ, λ, γ) : z
end
export ampd

end # module PingPongScoreCounter
