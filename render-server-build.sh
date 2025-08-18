#!/bin/bash
set -e

echo "Starting server build process..."

# Update package lists
apt-get update

# Install essential build tools
apt-get install -y \
  python3 \
  python3-dev \
  python3-pip \
  build-essential \
  pkg-config \
  libtool \
  autoconf \
  automake

# Install node-gyp globally
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