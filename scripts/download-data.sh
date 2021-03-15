#!/bin/bash

# variables
default_exchange='binanceus'
exchange=${1:-$default_exchange}
default_days=30
days=${2:-$default_days}

docker-compose run --rm \
  freqtrade download-data \
  -t 1m 5m 15m 1h \
  --config /freqtrade/user_data/config.json \
  --config /freqtrade/user_data/config-secret.$exchange.json \
  -vvv \
  --days $days