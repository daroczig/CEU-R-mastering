library(binancer)
library(data.table)
library(logger)
library(checkmate)

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

# get prices from Binance - if there is an error: use tryCatch
prices <- binance_ticker_all_prices()
prices

# search for BTC, USD
btc_usd <- prices[from == 'BTC' & to == 'USDT', price]
ex1 <- btc_usd * BITCOINS
log_info('BTCUSDT: {btc_usd}')

# tryCatch
get_bitcoin_price <- function() {
  tryCatch(
  binance_coins_prices()[symbol == 'BTC', usd],
                       error = function(e) get_bitcoin_price())
}

btcusd <- get_bitcoin_price()

log_info('BTCUSDT: {btcusd}')

# check the values from the function
assert_number(btcusd, lower = 10000)

# how to get currency rates?
readLines('https://api.exchangeratesapi.io/latest?base=USD')

# parse the json object
library(jsonlite)

# FX rate USDHUF
usd_huf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD')$rates$HUF
log_info('USDHUF: {usd_huf}')
assert_number(usd_huf, lower = 250 , upper = 500)

# solution for the 2nd exercise
ex_2 <- ex1*usd_huf
ex_2
