#!/bin/bash
set -e

echo "Starting collector build process..."

# Install node-gyp globally (Render provides build tools)
npm install -g node-gyp

echo "Build tools installed, starting collector dependencies..."

# Change to collector directory and install dependencies
cd collector

# Install with longer timeout and verbose logging
yarn install --network-timeout 100000 --verbose

echo "Collector build completed successfully!"