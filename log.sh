#!/bin/bash
# Continuously tail logs from all running docker containers with container names for clarity

while true; do
    # Get all running container IDs
    CONTAINERS=$(docker ps -q)
    if [ -z "$CONTAINERS" ]; then
        echo "No running containers found."
        sleep 5
        continue
    fi

    # Use docker logs -f for each container in the background
    for CID in $CONTAINERS; do
        NAME=$(docker inspect --format='{{.Name}}' "$CID" | sed 's/\///')
        # Start tailing logs in background, prefixing each line with the container name
        docker logs -f "$CID" 2>&1 | sed "s/^/[$NAME] /" &
        PIDS="$PIDS $!"
    done

    # Wait for all tails to exit (e.g., if containers stop)
    wait

    # Clean up background processes before restarting if needed
    PIDS=""
    sleep 1
done
