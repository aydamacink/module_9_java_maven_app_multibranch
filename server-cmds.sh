#!/usr/bin/env bash

# Assign the first argument to IMAGE
IMAGE=$1

# Print the IMAGE variable for debugging
echo "Deploying Image: $IMAGE"

# Export IMAGE and run docker-compose in the same command
IMAGE=$IMAGE docker-compose -f docker-compose.yaml up --detach
echo "success"