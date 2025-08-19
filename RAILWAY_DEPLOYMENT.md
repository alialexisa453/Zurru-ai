# AnythingLLM Railway Deployment Guide

Railway offers better support for native modules and provides a more robust deployment environment for AnythingLLM compared to Render's free tier.

## 🚀 Quick Start

### Prerequisites
1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **OpenRouter API Key**: Get from [openrouter.ai](https://openrouter.ai) (add $5+ credits)
3. **GitHub Repository**: Your AnythingLLM fork connected to Railway

## 📋 Deployment Steps

### Step 1: Create Railway Project

1. **New Project**: Go to Railway dashboard → "New Project"
2. **Deploy from GitHub**: Select your AnythingLLM repository
3. **Choose Template**: Select "Empty Project" for custom configuration

### Step 2: Add PostgreSQL Database

1. **Add Service**: Click "+" → "Database" → "PostgreSQL"
2. **Wait for Deployment**: Railway will provision the database
3. **Note Variables**: Railway auto-generates `DATABASE_URL`

### Step 3: Deploy Server Service

1. **Add Service**: Click "+" → "GitHub Repo" → Select your repo
2. **Service Settings**:
   - **Name**: `anythingllm-server`
   - **Root Directory**: `server`
   - **Build Command**: `yarn install && npx prisma generate`
   - **Start Command**: `yarn start`

3. **Environment Variables**:
   ```
   NODE_ENV=production
   JWT_SECRET=[Railway auto-generates]
   SIG_KEY=[Railway auto-generates]
   SIG_SALT=[Railway auto-generates]
   DATABASE_URL=${{Postgres.DATABASE_URL}}
   VECTOR_DB=lancedb
   LLM_PROVIDER=openrouter
   OPENROUTER_API_KEY=[Your OpenRouter API key]
   OPENROUTER_MODEL_PREF=anthropic/claude-3-haiku
   EMBEDDING_ENGINE=native
   EMBEDDING_MODEL_PREF=Xenova/all-MiniLM-L6-v2
   WHISPER_PROVIDER=local
   TTS_PROVIDER=native
   DISABLE_TELEMETRY=true
   ```

4. **Generate Domain**: Settings → "Generate Domain"

### Step 4: Deploy Collector Service

1. **Add Service**: Click "+" → "GitHub Repo" → Select your repo
2. **Service Settings**:
   - **Name**: `anythingllm-collector`
   - **Root Directory**: `collector`
   - **Start Command**: `yarn start`

3. **Environment Variables**:
   ```
   NODE_ENV=production
   ```

4. **Generate Domain**: Settings → "Generate Domain"

### Step 5: Deploy Frontend (Vercel)

Railway works best for backend services. For the frontend, use Vercel:

1. **Vercel Dashboard**: Import your GitHub repository
2. **Framework**: Select "Vite"
3. **Build Settings**:
   - **Build Command**: `cd frontend && yarn build`
   - **Output Directory**: `frontend/dist`
   - **Root Directory**: `frontend`

4. **Environment Variables**:
   ```
   VITE_API_BASE=https://[your-railway-server-domain]/api
   ```

### Step 6: Initialize Database

1. **Railway Console**: Go to server service → "Console"
2. **Run Migrations**:
   ```bash
   npx prisma migrate deploy
   npx prisma db seed
   ```

## 🎯 OpenRouter Configuration

### Environment Variables
- `OPENROUTER_API_KEY`: Your API key from OpenRouter
- `OPENROUTER_MODEL_PREF`: Recommended model (see below)

### Recommended Models
- **Cost-Effective**: `anthropic/claude-3-haiku` ($0.25/1M tokens)
- **Balanced**: `openai/gpt-4o-mini` ($0.15/1M tokens)
- **High Performance**: `anthropic/claude-3.5-sonnet` ($3/1M tokens)
- **Auto-Selection**: `openrouter/auto` (automatically picks best model)

## 💰 Railway Pricing

- **Free Trial**: $5 credit (expires in 30 days)
- **Hobby Plan**: $5/month + usage
- **Usage Charges**: Pay only for what you use (CPU, RAM, storage)

### Estimated Monthly Costs:
- PostgreSQL: ~$2-5/month
- Server Service: ~$3-7/month
- Collector Service: ~$2-5/month
- **Total**: ~$7-17/month + OpenRouter usage

## 🔧 Configuration Files

The deployment includes these Railway-specific configs:

- `/railway.json` - Root project configuration
- `/server/railway.json` - Server service configuration
- `/collector/railway.json` - Collector service configuration
- `/server/.env.railway` - Server environment template
- `/collector/.env.railway` - Collector environment template

## 🚨 Troubleshooting

### Build Failures
- Railway has better native module support than Render
- If builds still fail, try upgrading to Pro plan for more resources

### Database Connection Issues
- Verify `DATABASE_URL` is connected: `${{Postgres.DATABASE_URL}}`
- Check database service is running and accessible

### Frontend API Connection
- Ensure `VITE_API_BASE` points to your Railway server domain
- Verify CORS settings allow your Vercel domain

### Environment Variables
- Use Railway's variable references: `${{ServiceName.VARIABLE_NAME}}`
- Auto-generated secrets: Railway creates JWT_SECRET, SIG_KEY, SIG_SALT

## 🎉 Success Checklist

- [ ] PostgreSQL database deployed and accessible
- [ ] Server service running with all environment variables
- [ ] Collector service running
- [ ] Database migrations completed
- [ ] Frontend deployed to Vercel with API connection
- [ ] OpenRouter API key configured with sufficient credits
- [ ] All services generating proper logs

## 🔗 Useful Links

- [Railway Documentation](https://docs.railway.com/)
- [Railway Monorepo Guide](https://docs.railway.com/guides/monorepo)
- [OpenRouter Dashboard](https://openrouter.ai/keys)
- [Vercel Dashboard](https://vercel.com/dashboard)

Railway's superior build environment and native module support should resolve the compilation issues encountered with Render's free tier!