#!/bin/bash
set -e

echo "Starting minimal collector build for free tier..."

# Conservative memory settings for free tier  
export NODE_OPTIONS="--max-old-space-size=512"

# Change to collector directory
cd collector

echo "Installing only production dependencies..."
# Skip heavy dev dependencies and optional modules
yarn install --production --ignore-optional --network-timeout 300000

echo "Collector build completed successfully!"