#!/bin/bash
set -e

echo "Starting collector build process..."

# Update package lists
apt-get update

# Install comprehensive build dependencies for image processing
apt-get install -y \
  python3 \
  python3-dev \
  python3-pip \
  build-essential \
  pkg-config \
  libtool \
  autoconf \
  automake \
  libvips-dev \
  libvips-tools \
  libcairo2-dev \
  libjpeg-dev \
  libpng-dev \
  libgif-dev \
  libwebp-dev \
  libtiff-dev

# Install node-gyp globally
npm install -g node-gyp

echo "Build tools installed, starting collector dependencies..."

# Change to collector directory and install dependencies
cd collector

# Install with longer timeout and verbose logging
yarn install --network-timeout 100000 --verbose

echo "Collector build completed successfully!"