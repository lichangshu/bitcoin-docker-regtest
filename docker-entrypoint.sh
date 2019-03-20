#!/bin/bash
set -eo pipefail

service cron start

exec /opt/bitcoin-0.17.1/bin/bitcoind "$@"
