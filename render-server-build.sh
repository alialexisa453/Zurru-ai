#!/bin/bash
set -e

echo "Starting server build process..."

# Install node-gyp globally (no system packages needed on Render)
npm install -g node-gyp

echo "Build tools installed, starting server dependencies..."

# Change to server directory and install dependencies
cd server
yarn install --network-timeout 100000

echo "Setting up production database schema..."
# Copy production schema over the main schema
cp prisma/schema.production.prisma prisma/schema.prisma

echo "Running Prisma generation..."
npx prisma generate

echo "Server build completed successfully!"