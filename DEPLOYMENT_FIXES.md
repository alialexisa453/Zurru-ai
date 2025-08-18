# Deployment Fixes for Render

## Issues Fixed

### 1. Node.js Version Issue
- **Problem**: Node.js 18.18.0 is end-of-life and causing build issues
- **Fix**: Updated `.nvmrc` to use Node.js 20.11.0 (LTS)

### 2. Missing node-gyp Dependency
- **Problem**: `sharp` package requires `node-gyp` for native compilation
- **Fix**: Added `node-gyp` installation to build scripts and Dockerfiles

### 3. Missing System Dependencies
- **Problem**: Native modules require system libraries for compilation
- **Fix**: Added system dependencies to build scripts:
  - python3, python3-dev, python3-pip
  - build-essential (make, g++)
  - Graphics libraries (cairo, jpeg, png, etc.)

## Updated Files

1. **`.nvmrc`**: Updated to Node.js 20.11.0
2. **`render.yaml`**: Updated build commands to use custom scripts
3. **`render-build.sh`**: New build script for server with dependencies
4. **`collector-build.sh`**: New build script for collector with dependencies
5. **`server/Dockerfile.render`**: Added system dependencies and node-gyp
6. **`collector/Dockerfile.render`**: Added system dependencies and node-gyp

## Render Deployment Steps (Updated)

1. **Push the updated code** to your GitHub repository
2. **In Render Dashboard**:
   - Delete the existing failed service (if any)
   - Create a new Web Service
   - Connect your GitHub repository
   - Use these settings:
     - **Environment**: Node
     - **Build Command**: `./render-build.sh`
     - **Start Command**: `cd server && yarn start`
     - **Node Version**: Will use 20.11.0 from `.nvmrc`

3. **Environment Variables** (same as before):
   ```
   NODE_ENV=production
   SERVER_PORT=10000
   DATABASE_URL=[Your PostgreSQL connection string]
   JWT_SECRET=[32+ character random string]
   SIG_KEY=[32+ character random string]
   SIG_SALT=[32+ character random string]
   VECTOR_DB=lancedb
   EMBEDDING_ENGINE=native
   EMBEDDING_MODEL_PREF=Xenova/all-MiniLM-L6-v2
   WHISPER_PROVIDER=local
   TTS_PROVIDER=native
   ```

## If Build Still Fails

If you still encounter issues, try these alternative approaches:

### Option 1: Manual Build Command
Instead of using the build script, use this manual build command:
```bash
apt-get update && apt-get install -y python3 python3-dev build-essential && npm install -g node-gyp && cd server && yarn install && yarn prisma:generate
```

### Option 2: Remove Sharp Dependency
If `sharp` is causing issues and isn't critical for your use case, you can temporarily remove it:
1. Remove `sharp` from `collector/package.json`
2. Comment out any sharp-related code in the collector

### Option 3: Use Docker Build
Instead of using Render's native Node.js environment, you can:
1. Use the provided Dockerfiles
2. Set Render to use Docker instead of Node.js environment

## Testing Locally

Before deploying, you can test the build process locally:

```bash
# Test server build
./render-build.sh

# Test collector build  
./collector-build.sh
```

This will help identify any remaining issues before deployment.