#!/bin/bash

# Fetch the external IP address
EXT_IP=$(wget -qO- https://api.ipify.org)

if [ -z "$EXT_IP" ]; then
    echo "Failed to fetch external IP address."
    exit 1
fi

# Execute the Energi node with dynamic IP
exec /home/energiuser/energi3/bin/energi3 --testnet \
    --gcmode archive \
    --maxpeers 128 \
    --masternode \
    --mine=1 \
    --nat extip:$EXT_IP \
    --verbosity 3