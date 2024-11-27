#!/bin/sh

# Fetch the external IP address
EXT_IP=$(curl -s https://api.ipify.org)

if [ -z "$EXT_IP" ]; then
    echo "Failed to fetch external IP address."
    exit 1
fi

# Execute the Energi node
#exec /home/energiuser/energi3/bin/energi3 \
#    --datadir /home/energiuser/.energicore3 \
#    --gcmode archive \
#    --maxpeers 128 \
#    --masternode \
#    --mine=1 \
#    --nat extip:$EXT_IP \
#    --verbosity 3