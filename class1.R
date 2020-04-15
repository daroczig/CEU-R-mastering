library(binancer)
library(data.table)
library(logger)

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

# get prices from Binance
prices <- binance_ticker_all_prices()
prices

# search for BTC, USD
btc_usd <- prices[from == 'BTC' & to == 'USDT', price]
ex1 <- btc_usd * BITCOINS
log_info('BTCUSDT: {btc_usd}')

# how to get currency rates?
readLines('https://api.exchangeratesapi.io/latest?base=USD')

# parse the json object
library(jsonlite)

# FX rate USDHUF
usd_huf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD')$rates$HUF
log_info('USDHUF: {usd_huf}')

# solution for the 2nd exercise
ex_2 <- ex1*usd_huf
ex_2