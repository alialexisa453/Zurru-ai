#!/bin/bash

# Install build dependencies
apt-get update
apt-get install -y python3 python3-dev python3-pip build-essential

# Install node-gyp globally
npm install -g node-gyp

# Install server dependencies
cd server
yarn install
yarn prisma:generate