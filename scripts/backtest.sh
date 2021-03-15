#!/bin/bash

# Help text
if [[ "$1" == *"help"* ]]; then
  echo "Usage: ./scripts/backtest.sh [strategy] [startdate] [enddate] [exchange]"
  echo -e "\ne.g. ./scripts/backtest.sh RSIStochStrategy 20200101 20201231 binanceus\n"
  echo 'Default Strategy: $STRATEGY or WeightedBBRSIStrategy if $STRATEGY is not declared in the env vars'
  echo "Default start date: 30 days ago"
  echo "Default end date: today"
  echo "Default exchange: binanceus"
  exit 0
fi

# variables
default_strategy=${STRATEGY:-WeightedBBRSIStrategy}
test_strategy=${1:-$default_strategy}

current_date=$(date '+%Y%m%d')
default_start_date=$(date -v-30d '+%Y%m%d') # Default - 30 days ago

start_date=${2:-$default_start_date}
end_date=${3:-$current_date}

default_exchange='binanceus'
exchange=${4:-$default_exchange}

echo "Backtesting with strategy: $test_strategy"
sleep 3
docker-compose run --rm \
  freqtrade backtesting \
  -s $test_strategy \
  --config /freqtrade/user_data/config.json \
  --config /freqtrade/user_data/config-secret.$exchange.json \
  --config /freqtrade/user_data/config-backtesting.json \
  --export=trades \
  --export-filename=user_data/backtest_results/30day-$(git rev-parse --short HEAD).json \
  --timerange=$start_date-$end_date