# AnythingLLM Deployment Guide: Vercel + Render

This guide covers deploying AnythingLLM with the frontend on Vercel and backend services on Render.

## Prerequisites

- [Vercel](https://vercel.com) account
- [Render](https://render.com) account
- GitHub repository with your AnythingLLM code

## Architecture Overview

- **Frontend**: React app deployed on Vercel
- **Backend Server**: Node.js API server deployed on Render
- **Collector**: Document processing service deployed on Render
- **Database**: PostgreSQL managed database on Render

## 1. Database Setup (Render)

1. Log into your Render dashboard
2. Create a new PostgreSQL database:
   - Name: `anythingllm-db`
   - Database Name: `anythingllm`
   - User: `anythingllm`
3. Note the connection string for later use

## 2. Backend Server Deployment (Render)

1. Create a new Web Service on Render
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `anythingllm-server`
   - **Environment**: `Node`
   - **Build Command**: `cd server && yarn install && yarn prisma:generate`
   - **Start Command**: `cd server && yarn start`
   - **Plan**: Starter (or higher based on needs)

4. Set Environment Variables:
   ```
   NODE_ENV=production
   SERVER_PORT=10000
   DATABASE_URL=[Your PostgreSQL connection string from step 1]
   JWT_SECRET=[Generate a secure 32+ character random string]
   SIG_KEY=[Generate a secure 32+ character random string]
   SIG_SALT=[Generate a secure 32+ character random string]
   VECTOR_DB=lancedb
   EMBEDDING_ENGINE=native
   EMBEDDING_MODEL_PREF=Xenova/all-MiniLM-L6-v2
   WHISPER_PROVIDER=local
   TTS_PROVIDER=native
   ```

5. Optional LLM Provider Configuration (add as needed):
   ```
   LLM_PROVIDER=openai
   OPEN_AI_KEY=[Your OpenAI API key]
   OPEN_MODEL_PREF=gpt-4o
   ```

6. Deploy the service
7. Note the service URL (e.g., `https://anythingllm-server-xxxx.onrender.com`)

## 3. Document Collector Deployment (Render)

1. Create another new Web Service on Render
2. Configure the service:
   - **Name**: `anythingllm-collector`
   - **Environment**: `Node`
   - **Build Command**: `cd collector && yarn install`
   - **Start Command**: `cd collector && yarn start`
   - **Plan**: Starter (or higher based on needs)

3. Set Environment Variables:
   ```
   NODE_ENV=production
   SERVER_PORT=10000
   ```

4. Deploy the service
5. Note the service URL (e.g., `https://anythingllm-collector-xxxx.onrender.com`)

## 4. Frontend Deployment (Vercel)

1. Log into your Vercel dashboard
2. Import your GitHub repository
3. Configure the project:
   - **Framework Preset**: Vite
   - **Root Directory**: Leave empty (uses root)
   - **Build Command**: `cd frontend && yarn build`
   - **Output Directory**: `frontend/dist`
   - **Install Command**: `yarn install && cd frontend && yarn install`

4. Set Environment Variables:
   ```
   VITE_API_BASE=https://[your-render-server-url].onrender.com/api
   ```
   Replace `[your-render-server-url]` with your actual Render server URL from step 2.7

5. Deploy the project

## 5. Database Migration

After both backend services are deployed:

1. Access your Render server service dashboard
2. Open the "Shell" tab to access the terminal
3. Run database migrations:
   ```bash
   cd server
   npx prisma migrate deploy
   npx prisma db seed
   ```

## 6. Configuration Updates

Update your server environment variables to allow CORS from your Vercel domain:

```
CORS_ORIGIN=https://[your-vercel-app].vercel.app
```

## 7. Testing the Deployment

1. Visit your Vercel frontend URL
2. Try creating a workspace
3. Upload a document to test the collector service
4. Start a chat to test the full pipeline

## Important Notes

### File Storage
- The current setup uses local file storage on Render
- For production, consider configuring external storage (AWS S3, etc.)
- Render services have ephemeral storage that resets on deploys

### Database Backups
- Render provides automatic daily backups for PostgreSQL
- Consider setting up additional backup strategies for production

### Environment Variables Security
- Never commit API keys or secrets to your repository
- Use Render's environment variable management
- Generate strong, unique secrets for JWT_SECRET, SIG_KEY, and SIG_SALT

### Scaling Considerations
- Start with Render's Starter plan and upgrade as needed
- Monitor resource usage and performance
- Consider upgrading to Render's Pro plan for production workloads

### SSL/HTTPS
- Both Vercel and Render provide SSL certificates automatically
- Ensure all API calls use HTTPS in production

## Troubleshooting

### Frontend can't connect to backend
- Verify the `VITE_API_BASE` environment variable in Vercel
- Check CORS configuration on the server
- Ensure the Render server is deployed and running

### Database connection issues
- Verify the `DATABASE_URL` environment variable
- Check if migrations have been run
- Ensure the PostgreSQL service is running on Render

### Document upload/processing issues
- Check the collector service logs in Render
- Verify the collector service is running
- Check network connectivity between services

## Cost Optimization

- **Render**: Starter plan (~$7/month per service)
- **Vercel**: Hobby plan (free for personal projects)
- **PostgreSQL**: Starter plan (~$7/month)

Total estimated cost: ~$21/month for a basic production setup.

For development/testing, you can use Render's free tier with limitations.