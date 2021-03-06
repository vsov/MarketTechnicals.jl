function bollingerbands{T,N}(ta::TimeArray{T,N}, ma::Int, width::Float64)
    tama   = sma(ta, ma)
    upband = tama .+ moving(ta, std, ma) .* width .* sqrt((ma-1)/ma) # take out Bessel correction, per algorithm
    dnband = tama .- moving(ta, std, ma) .* width .* sqrt((ma-1)/ma)
    bands  =  merge(upband, dnband) 
    merge(bands, tama, colnames=["up", "down", "mean"])
end

bollingerbands{T,N}(ta::TimeArray{T,N}) = bollingerbands(ta, 20, 2.0)

function truerange{T,N}(ohlc::TimeArray{T,N}; h="High", l="Low", c="Close")
    highs    = merge(ohlc[h], lag(ohlc[c]))
    lows     = merge(ohlc[l], lag(ohlc[c]))
    truehigh = TimeArray(highs.timestamp, maximum(highs.values, 2), ["hi"])
    truelow  = TimeArray(lows.timestamp,  minimum(lows.values, 2),  ["lo"])
    truehigh .- truelow
end

function atr{T,N}(ohlc::TimeArray{T,N}, n::Int; h="High", l="Low", c="Close")
    # atr was inveted by Wilder, so only his ema is supported
    res = ema(truerange(ohlc), n, wilder=true)
    TimeArray(res.timestamp, res.values, ["atr"])
end
  
atr{T,N}(ta::TimeArray{T,N}) = atr(ta, 14)

# function keltnerbands{T,N}(hi::Array{SeriesPair{T,N},1},
#                            lo::Array{SeriesPair{T,N},1},
#                            cl::Array{SeriesPair{T,N},1}, n::Int)
# 
#   idx = index(hi)[n:end]
#   typ = (value(hi) + value(lo) + value(cl)) / 3
#   rng = value(hi) - value(lo)
#   rma = sma(rng, n) 
#  
#   kma = sma(typ, n) 
#   kup = kma + rma/2 
#   kdn = kma - rma/2 
#   
#   SeriesArray(idx, kma), SeriesArray(idx, kup), SeriesArray(idx, kdn)
# end
  
# # keltner_bands(df::DataFrame) = keltner_bands(df::DataFrame, 10)
 
# # function chaikinvolatility{T,N}(ta::TimeArray{T,N}, n::Int)
# #   #code here
# # end
