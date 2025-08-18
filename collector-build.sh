#!/bin/bash

# Install build dependencies for collector
apt-get update
apt-get install -y python3 python3-dev python3-pip build-essential \
    libcairo2-dev libjpeg-dev libgif-dev libpng-dev

# Install node-gyp globally  
npm install -g node-gyp

# Install collector dependencies
cd collector
yarn install