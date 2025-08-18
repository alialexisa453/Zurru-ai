# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Installation
- `yarn setup` - Initial setup: installs dependencies, creates ENV files, runs Prisma setup
- `yarn dev:all` - Run all services in development mode with hot reload (server, frontend, collector)
- `yarn dev:server` - Run only the server in development mode
- `yarn dev:frontend` - Run only the frontend in development mode  
- `yarn dev:collector` - Run only the document collector in development mode

### Building and Production
- `yarn prod:frontend` - Build the frontend for production
- `yarn prod:server` - Start the server in production mode

### Database Operations
- `yarn prisma:generate` - Generate Prisma client
- `yarn prisma:migrate` - Run database migrations
- `yarn prisma:seed` - Seed the database
- `yarn prisma:setup` - Complete Prisma setup (generate, migrate, seed)
- `yarn prisma:reset` - Reset database and re-run migrations

### Code Quality
- `yarn lint` - Format and lint all code (server, frontend, collector)
- `yarn test` - Run Jest tests

### Translation Management
- `yarn verify:translations` - Verify translation files integrity
- `yarn normalize:translations` - Normalize English translations and run verification

## Architecture Overview

AnythingLLM is a full-stack application with three main components:

### Core Components
1. **Server** (`/server`) - Node.js/Express backend handling:
   - API endpoints for chat, documents, workspaces
   - LLM provider integrations (OpenAI, Anthropic, Ollama, etc.)
   - Vector database management (LanceDB, Pinecone, Chroma, etc.)
   - User authentication and workspace management
   - Agent flows and MCP server support

2. **Frontend** (`/frontend`) - React/Vite application providing:
   - Chat interface with multi-modal support
   - Workspace management UI
   - Admin panel for system configuration
   - Document upload and management
   - Agent configuration interface

3. **Collector** (`/collector`) - Document processing service handling:
   - File parsing (PDF, DOCX, TXT, etc.)
   - Web scraping and link processing
   - Text chunking and embedding preparation
   - OCR and audio transcription

### Key Architectural Patterns

#### Workspace-based Document Organization
- Documents are organized into isolated "workspaces" (like threads)
- Each workspace maintains its own context and document collection
- Workspaces can share documents but maintain separate chat histories

#### Provider Abstraction Layer
- Modular LLM provider system in `/server/utils/AiProviders/`
- Standardized interface for different LLM services
- Similar pattern for embedding engines and vector databases

#### Multi-tenant Support
- Role-based permissions system
- Multi-user workspace sharing (Docker deployments)
- API key management for different access levels

## Development Guidelines

### Environment Configuration
- Server environment: `/server/.env.development`
- Frontend environment: `/frontend/.env`
- Collector environment: `/collector/.env`
- Docker environment: `/docker/.env`

### Testing Requirements
- Unit tests are required for all bug fixes and new features
- Use Jest for testing framework
- Test error cases with clear error messages

### Database Schema
- Uses Prisma ORM with SQLite (default) or PostgreSQL
- Migration files in `/server/prisma/migrations/`
- Schema defined in `/server/prisma/schema.prisma`

### API Structure
- REST API endpoints in `/server/endpoints/`
- OpenAI-compatible API endpoints for external integrations
- WebSocket support for real-time chat features

### Frontend Patterns
- React with Vite build system
- Tailwind CSS for styling
- Context providers for global state (Auth, Theme, etc.)
- Component-based architecture with reusable UI elements

### Integration Development
- LLM integrations go in `/server/utils/AiProviders/[provider]/`
- Vector DB integrations in `/server/utils/vectorDbProviders/[provider]/`
- Follow existing patterns for configuration and error handling
- Include model discovery and validation where applicable