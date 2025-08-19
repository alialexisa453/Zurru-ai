#!/bin/bash
set -e

echo "Starting minimal server build for free tier..."

# Conservative memory settings for free tier
export NODE_OPTIONS="--max-old-space-size=512"

# Change to server directory
cd server

echo "Installing only production dependencies..."
# Skip heavy dev dependencies and native modules that may fail
yarn install --production --ignore-optional --network-timeout 300000

echo "Setting up production database schema..."
cp prisma/schema.production.prisma prisma/schema.prisma

echo "Running Prisma generation..."
npx prisma generate

echo "Server build completed successfully!"