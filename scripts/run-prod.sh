#!/bin/bash

# Help text
if [[ "$1" == *"help"* ]]; then
  echo "Usage: ./scripts/run.sh [strategy] [exchange]"
  echo -e "\ne.g. ./scripts/run.sh BinHV45Strategy binanceus\n"
  echo 'Default Strategy: $STRATEGY or BinHV45Strategy if $STRATEGY is not declared in the env vars'
  echo "Default exchange: binanceus"
  exit 0
fi

read -p "Do you wish to run in PROD mode with real money? " yn
case $yn in
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
esac

# variables
default_strategy=${STRATEGY:-BinHV45Strategy}
run_strategy=${1:-$default_strategy}

default_exchange='binanceus'
exchange=${4:-$default_exchange}

echo "Running freqtrade in PROD with strategy: $run_strategy"
sleep 3
docker-compose run \
  freqtrade trade \
  --logfile /freqtrade/user_data/logs/freqtrade.log \
  --config /freqtrade/user_data/config.json \
  --config /freqtrade/user_data/config-secret.$exchange.json \
  --config /freqtrade/user_data/config-prod.json \
  --db-url sqlite:////freqtrade/user_data/tradesv3-prod.sqlite \
  --strategy ${run_strategy}