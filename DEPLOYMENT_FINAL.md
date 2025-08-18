# Final AnythingLLM Deployment Guide: Vercel + Render

## ✅ Issues Fixed

1. **Node.js Version**: Updated to Node.js 20.11.0 (LTS)
2. **Build Dependencies**: Added comprehensive system dependencies for native modules
3. **Sharp/node-gyp Issues**: Resolved with proper build environment setup
4. **Database Schema**: Separate schemas for development (SQLite) and production (PostgreSQL)
5. **OpenRouter Integration**: Pre-configured for easy LLM provider setup

## 🚀 Quick Start

### Step 1: Get Your OpenRouter API Key
1. Sign up at [openrouter.ai](https://openrouter.ai)
2. Add credits (minimum $10 for production)
3. Copy your API key from the Keys page

### Step 2: Deploy to Render (Backend)

1. **Create PostgreSQL Database**:
   - Go to Render Dashboard → New → PostgreSQL
   - Database Name: `anythingllm`
   - User: `anythingllm`
   - Copy the connection string

2. **Deploy Server Service**:
   - Go to Render Dashboard → New → Web Service
   - Connect your GitHub repository
   - Settings:
     - **Name**: `anythingllm-server`
     - **Environment**: Node
     - **Build Command**: `./render-server-build.sh`
     - **Start Command**: `cd server && yarn start`
     - **Plan**: Starter or higher

3. **Environment Variables for Server**:
   ```
   NODE_ENV=production
   SERVER_PORT=10000
   JWT_SECRET=[Generate 32+ char random string]
   SIG_KEY=[Generate 32+ char random string]
   SIG_SALT=[Generate 32+ char random string]
   DATABASE_URL=[Your PostgreSQL connection string]
   VECTOR_DB=lancedb
   EMBEDDING_ENGINE=native
   EMBEDDING_MODEL_PREF=Xenova/all-MiniLM-L6-v2
   WHISPER_PROVIDER=local
   TTS_PROVIDER=native
   LLM_PROVIDER=openrouter
   OPENROUTER_API_KEY=[Your OpenRouter API key]
   OPENROUTER_MODEL_PREF=anthropic/claude-3-haiku
   ```

4. **Deploy Collector Service**:
   - Create another Web Service
   - Settings:
     - **Name**: `anythingllm-collector`
     - **Environment**: Node
     - **Build Command**: `./render-collector-build.sh`
     - **Start Command**: `cd collector && yarn start`
     - **Plan**: Starter or higher

5. **Environment Variables for Collector**:
   ```
   NODE_ENV=production
   SERVER_PORT=10000
   ```

### Step 3: Deploy to Vercel (Frontend)

1. **Connect Repository**:
   - Go to Vercel Dashboard → New Project
   - Import your GitHub repository

2. **Project Settings**:
   - **Framework Preset**: Vite
   - **Build Command**: `cd frontend && yarn build`
   - **Output Directory**: `frontend/dist`
   - **Install Command**: `yarn install && cd frontend && yarn install`

3. **Environment Variables**:
   ```
   VITE_API_BASE=https://[your-render-server-url].onrender.com/api
   ```

### Step 4: Initialize Database

After server deployment succeeds:

1. Go to your Render server service dashboard
2. Open the "Shell" tab
3. Run migrations:
   ```bash
   cd server
   npx prisma migrate deploy
   npx prisma db seed
   ```

## 🎯 OpenRouter Model Recommendations

### Cost-Effective Options:
- `anthropic/claude-3-haiku` - Fast and economical ($0.25/1M tokens)
- `openai/gpt-4o-mini` - Good performance, low cost ($0.15/1M tokens)
- `meta-llama/llama-3.1-8b-instruct:free` - Free tier (limited requests)

### High Performance:
- `anthropic/claude-3.5-sonnet` - Excellent reasoning ($3/1M tokens)
- `openai/gpt-4o` - Great all-around performance ($2.50/1M tokens)
- `google/gemini-pro-1.5` - Large context window ($1.25/1M tokens)

### Auto-Selection:
- `openrouter/auto` - Automatically selects best model for each prompt

## 🔧 Local Development

For local development, the setup is already configured:

1. **Run setup**:
   ```bash
   yarn setup
   yarn prisma:setup
   ```

2. **Start services**:
   ```bash
   yarn dev:all
   ```

3. **Update OpenRouter API key** in `server/.env.development`

## 📋 Deployment Checklist

### Before Deploying:
- [ ] Update OpenRouter API key in environment variables
- [ ] Generate secure random strings for JWT_SECRET, SIG_KEY, SIG_SALT
- [ ] Ensure GitHub repository is up to date

### After Server Deployment:
- [ ] Verify server is running (check logs)
- [ ] Run database migrations
- [ ] Test API endpoints

### After Frontend Deployment:
- [ ] Update VITE_API_BASE with actual server URL
- [ ] Test frontend-backend connectivity
- [ ] Create a workspace and upload a document
- [ ] Test chat functionality

## 🚨 Troubleshooting

### Build Fails with node-gyp Error:
- The new build scripts should resolve this
- If still failing, try upgrading to Render's Pro plan for more build resources

### Database Connection Issues:
- Verify DATABASE_URL is correct
- Ensure PostgreSQL service is running
- Check network connectivity between services

### Frontend Can't Connect to Backend:
- Verify VITE_API_BASE environment variable
- Check CORS configuration
- Ensure server is deployed and accessible

### OpenRouter API Issues:
- Verify API key is correct
- Check you have sufficient credits
- Try a different model if one isn't working

## 💰 Cost Estimation

**Monthly Costs:**
- Render PostgreSQL: ~$7/month
- Render Server Service: ~$7/month
- Render Collector Service: ~$7/month
- Vercel Frontend: Free (Hobby plan)
- OpenRouter Usage: Variable based on usage

**Total: ~$21/month + OpenRouter usage**

## 🔐 Security Notes

- Never commit API keys to the repository
- Use strong, unique secrets for all security keys
- Regularly rotate API keys and secrets
- Monitor usage through OpenRouter dashboard
- Consider enabling AUTH_TOKEN for production access control

## 🎉 Success!

Once deployed, you'll have:
- A fully functional AnythingLLM instance
- Access to hundreds of AI models via OpenRouter
- Scalable cloud infrastructure
- Automatic HTTPS/SSL
- Document processing capabilities
- Multi-user support (if configured)

Visit your Vercel frontend URL to start using AnythingLLM!