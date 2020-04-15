library(binancer)
library(data.table)
a <- binance_klines('BTCUSDT', interval = '1m')

a$close

prices <- binance_ticker_all_prices()
prices
btc_usd <- prices[from == 'BTC' & to == 'USDT', price]
ex1 <- btc_usd * 0.42

# how to get currency rates?
readLines('https://api.exchangeratesapi.io/latest?base=USD')

# parse the json object
library(jsonlite)

usd_huf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD')$rates$HUF


ex_2 <- ex1*usd_huf
