---
name: devsecops
description: Use when setting up CI/CD pipelines, Docker configurations, infrastructure automation, deployment workflows, or production operations
---

# DevSecOps Skill

Activate this skill for CI/CD, containerization, deployment, and operations tasks.

## CI/CD Pipeline Setup

### GitHub Actions Template

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # Stage 1: Code Quality
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npm run typecheck

      - name: Format check
        run: npm run format:check

  # Stage 2: Testing
  test:
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Unit tests
        run: npm run test:unit

      - name: Integration tests
        run: npm run test:integration

      - name: Upload coverage
        uses: codecov/codecov-action@v4

  # Stage 3: Security
  security:
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Dependency audit
        run: npm audit --audit-level=high

      - name: Secret scanning
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified

      - name: SAST scan
        uses: github/codeql-action/analyze@v3

  # Stage 4: Build
  build:
    needs: [test, security]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build application
        run: npm run build

      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .

      - name: Push to registry
        if: github.ref == 'refs/heads/main'
        run: |
          docker tag app:${{ github.sha }} registry/app:latest
          docker push registry/app:latest

  # Stage 5: Deploy
  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to production
        run: |
          # Deploy commands here
          echo "Deploying..."
```

## Dockerfile Best Practices

### Multi-Stage Production Dockerfile

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./
RUN npm ci --only=production

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS runner

# Security: non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 appuser

WORKDIR /app

# Copy only necessary files
COPY --from=builder --chown=appuser:nodejs /app/dist ./dist
COPY --from=builder --chown=appuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:nodejs /app/package.json ./

# Security: switch to non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Environment
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["node", "dist/index.js"]
```

### Docker Security Checklist

```
[ ] Use official base images
[ ] Pin image versions (not :latest)
[ ] Multi-stage builds (smaller images)
[ ] Non-root user
[ ] Read-only filesystem where possible
[ ] No secrets in images
[ ] Health checks defined
[ ] Resource limits in compose/k8s
[ ] Scan images for vulnerabilities
```

## Docker Compose for Development

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: builder
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgres://user:pass@db:5432/app
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d app"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

## Deployment Checklist

### Pre-Deployment

```
[ ] All tests passing
[ ] Security scan clean
[ ] Database migrations tested
[ ] Rollback plan documented
[ ] Feature flags configured
[ ] Monitoring dashboards ready
[ ] Team notified
```

### During Deployment

```
[ ] Backup database before migrations
[ ] Deploy to staging first
[ ] Smoke tests on staging
[ ] Canary deployment if supported
[ ] Monitor error rates
[ ] Monitor latency
```

### Post-Deployment

```
[ ] Verify health checks passing
[ ] Check error rates normal
[ ] Verify key user flows
[ ] Monitor for 15-30 minutes
[ ] Update deployment log
[ ] Notify stakeholders
```

## Observability Setup

### Structured Logging Pattern

```typescript
// Logger configuration
const logger = {
  info: (message: string, meta?: object) => {
    console.log(JSON.stringify({
      level: 'info',
      message,
      timestamp: new Date().toISOString(),
      ...meta
    }));
  },
  error: (message: string, error: Error, meta?: object) => {
    console.error(JSON.stringify({
      level: 'error',
      message,
      error: {
        name: error.name,
        message: error.message,
        stack: error.stack
      },
      timestamp: new Date().toISOString(),
      ...meta
    }));
  }
};

// Usage with request context
app.use((req, res, next) => {
  req.requestId = crypto.randomUUID();
  req.log = {
    info: (msg, meta) => logger.info(msg, { requestId: req.requestId, ...meta }),
    error: (msg, err, meta) => logger.error(msg, err, { requestId: req.requestId, ...meta })
  };
  next();
});
```

### Health Check Endpoint

```typescript
app.get('/health', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION,
    checks: {}
  };

  // Database check
  try {
    await db.query('SELECT 1');
    health.checks.database = { status: 'healthy' };
  } catch (e) {
    health.checks.database = { status: 'unhealthy', error: e.message };
    health.status = 'unhealthy';
  }

  // Redis check
  try {
    await redis.ping();
    health.checks.redis = { status: 'healthy' };
  } catch (e) {
    health.checks.redis = { status: 'unhealthy', error: e.message };
    health.status = 'unhealthy';
  }

  const statusCode = health.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(health);
});
```

## Tool Integration

**Use these tools automatically for DevSecOps:**

```
CI/CD SETUP:
├── Context7 → GitHub Actions, Docker, K8s documentation
├── Tavily → Current best practices, security advisories
├── Episodic Memory → /search-conversations "CI/CD setup"
│   └─► Past pipeline configurations
├── Memory MCP → Recall deployment preferences
│   └─► "uses GitHub Actions", "deploys to Vercel"

DEPLOYMENT:
├── E2B → Test deployment scripts safely
│   └─► Run migrations, build processes in sandbox
├── GitHub MCP → Create PRs, check CI status
│   └─► Monitor deployment pipeline
├── Strawberry → Verify production configurations
│   └─► Security settings, environment variables

MONITORING:
├── Playwright → Health check verification
│   └─► Automated smoke tests
├── Tavily → Search for known issues
│   └─► "[service] outage", monitoring tools
├── GitHub MCP → Check for alerts, issues
│   └─► Dependabot, security alerts

INFRASTRUCTURE:
├── E2B → Test Terraform, Docker builds
│   └─► Validate before applying
├── Context7 → AWS, GCP, Azure documentation
├── Sequential Thinking → Complex infrastructure planning
│   └─► Multi-region, high availability
```

**Deployment Safety Pattern:**
```
1. E2B → Test migration script in sandbox
2. Strawberry → Verify production config is secure
3. GitHub MCP → Create PR with changes
4. Wait for CI to pass
5. Deploy to staging
6. Playwright → Run smoke tests
7. Deploy to production
8. Memory MCP → Store deployment notes
```

**Store Infrastructure Decisions:**
```
Memory MCP entities:
├── "Chose Vercel for deployment"
├── "Using GitHub Actions for CI"
├── "Database: PostgreSQL on Railway"
├── "Redis for session caching"
└── "Monitoring: Datadog"
```

## Related Skills

- @security-review - For security in deployments
- @implementation - For infrastructure code
- @planning - For deployment planning

---

*Automate everything. Test in staging. Monitor in production.*
