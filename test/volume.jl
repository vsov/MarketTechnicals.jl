using MarketData

facts("Volume") do

  context("obv") do
    @fact obv(ohlc).values[1]      => 50480000.00      # TTR value is 50480000
    @fact obv(ohlc).values[end]    => 1145460000.00    # TTR value is 1145460000 
    @fact obv(ohlc).timestamp[end] => lastday
  end 

  context("vwap") do
    @fact vwap(ohlc).values[1]     => roughly(109.0703)  # TTR value 109.0703
    @fact vwap(ohlc).values[end]   => roughly(122.7716)  # TTR value 122.7716
    @fact vwap(ohlc).timestamp[end] => lastday
  end
end
