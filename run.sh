#!/bin/bash

# Usage:
# ./run_earnapp_multiple_same_uuid.sh proxies.txt sdk-node-MYGENERATED_UUID
#
# proxies.txt: Each line is a proxy in the format protocol://user:pass@host:port or protocol://host:port
# sdk-node-MYGENERATED_UUID: The single EARNAPP_UUID to use for all containers

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 proxies.txt sdk-node-MYGENERATED_UUID"
    exit 1
fi

PROXY_FILE="$1"
UUID="$2"

mapfile -t PROXIES < "$PROXY_FILE"

for i in "${!PROXIES[@]}"; do
    PROXY="${PROXIES[$i]}"
    CONTAINER_NAME="earnapp_$((i+1))"
    
    # Remove container if it already exists
    docker rm -f "$CONTAINER_NAME" 2>/dev/null

    echo "Starting $CONTAINER_NAME with UUID=$UUID and PROXY=$PROXY..."
    docker run -d \
        -e EARNAPP_UUID="$UUID" \
        -e HTTP_PROXY="$PROXY" \
        -e HTTPS_PROXY="$PROXY" \
        --memory="256m" \
        --cpus=1.5 \
        --restart=always \
        --name "$CONTAINER_NAME" \
        trakkdev/earnapp
done
