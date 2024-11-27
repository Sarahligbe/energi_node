#!/bin/bash

# Fetch the external IP address. From https://github.com/energicryptocurrency/energi3-provisioning/blob/master/docker-compose/scripts/energi-core-run.sh
EXT_IP=$(curl -s https://api.ipify.org)

if [ -z "$EXT_IP" ]; then
    echo "Failed to fetch external IP address."
    exit 1
fi

# Execute the Energi node. From https://wiki.energi.world/docs/guides/core-node-linux#22-setup-auto-start
exec /home/energiuser/energi3/bin/energi3 \
    --datadir /home/energiuser/.energicore3 \
    --gcmode archive \
    --maxpeers 128 \
    --masternode \
    --nousb \
    --mine=1 \
    --nat extip:$EXT_IP \
    --verbosity 3