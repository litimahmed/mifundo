---

# ✅ **Pre-Coding Architecture Checklist**

*“From Diagrams to Code Without Regret”*

---

## 🧭 1. **Non-Functional Requirements (NFRs)**

- [ ] 💡 **Performance targets** (e.g., 95% of requests < 300ms)
- [ ] 🛡 **Security constraints** (e.g., HTTPS everywhere, RBAC, encryption)
- [ ] 📈 **Scalability model** (horizontal scaling? sharding?)
- [ ] ♻️ **Resilience / fault tolerance** (retry policies, timeouts, circuit breakers)
- [ ] 🧯 **Observability** (logs, metrics, tracing standards)
- [ ] 📦 **Deployment standards** (e.g., Docker, Kubernetes, cloud targets)
- [ ] 🔁 **Data consistency model** (strong, eventual, or compensating transactions)

---

## 🧩 2. **Integration & API Contracts**

- [ ] 📘 **REST APIs** fully designed in **OpenAPI** format (`.yaml` or `.json`)
- [ ] 🧬 **gRPC/Protobuf** contracts if using gRPC
- [ ] 🎙 **Event schemas** for pub/sub (e.g., `UserCreated`, `TenantProvisioned`)

  - Use something like [AsyncAPI](https://www.asyncapi.com/) if needed

- [ ] 💬 **Kafka or RabbitMQ topics** defined with:

  - Topic name conventions
  - Payload schema
  - Producer/consumer mappings

- [ ] 🧪 **Mock servers or contract tests** ready

---

## 🧰 3. **Tech Stack Finalization**

For each service (e.g., Auth, Notification, Content), confirm:

- [ ] ✅ Language + framework (e.g., NestJS for API, TypeORM, PostgreSQL)
- [ ] 🗃 Database engine per service (PostgreSQL, Redis, Mongo, etc.)
- [ ] ⚙️ Message broker (Kafka/RabbitMQ)
- [ ] ⛓ Auth strategy (JWT, OAuth2, API keys)
- [ ] 📦 Packaging (Docker, base images)
- [ ] 📂 Migration tool (e.g., Prisma Migrate, Alembic, Liquibase)

---

## 🏗 4. **Development Environment Setup**

- [ ] 🧱 Monorepo layout (Nx / Lerna / Turborepo / pnpm workspaces / plain folders)
- [ ] 🐳 `docker-compose.yml` for local dev with:

  - [ ] PostgreSQL
  - [ ] Redis
  - [ ] Kafka
  - [ ] MinIO (if needed for file storage)

- [ ] 📄 `.env.sample` for local environment variables
- [ ] 🛠 Global dev tools:

  - [ ] Prettier, ESLint, commit hooks
  - [ ] TypeScript base config (if TS)

- [ ] ✅ Reverse proxy setup (e.g., API Gateway locally via NGINX or BFF)
- [ ] 🚀 Scripts to start services easily (`make dev`, `pnpm dev`, etc.)

---

## 🧱 5. **Code Scaffolding per Service**

For each service (e.g., `auth-service`, `notification-service`):

- [ ] `src/` folder with structure:

  - `controllers/`
  - `services/`
  - `entities/`
  - `dtos/`
  - `config/`
  - `middleware/`

- [ ] `healthcheck` endpoint (`GET /health`)
- [ ] Logging system configured (e.g., Winston, Pino)
- [ ] Basic error handling middleware
- [ ] JWT validation middleware (if needed)
- [ ] `database.ts` or `ormconfig.js`
- [ ] Migration script and seed script
- [ ] Local test DB config

---

## 🧪 6. **Testing Foundation**

- [ ] Unit testing setup (e.g., Jest, Vitest, Mocha)
- [ ] Integration testing scaffold (e.g., Supertest or Testcontainers)
- [ ] Test DB with isolated schema
- [ ] Mock Kafka/RabbitMQ libraries (or test queues)

---

## 🧠 7. **Observability & DevOps Essentials**

- [ ] Centralized logging (structured logs w/ correlation IDs)
- [ ] Expose `/metrics` endpoint for Prometheus
- [ ] Enable OpenTelemetry traces (even if just local to start)
- [ ] Dockerfile ready for each service
- [ ] Basic GitHub Actions (or CI tool of choice):

  - Lint
  - Test
  - Build Docker image

---

## 📦 8. **Supporting Infrastructure**

- [ ] **API Gateway/BFF** configured with routing rules
- [ ] **Service discovery** (static for now or DNS-based)
- [ ] **Tenant resolution strategy** finalized:

  - Subdomain / Header / Token claim

- [ ] **Admin console vs. tenant app** boundaries finalized
- [ ] **Notification system routing rules**:

  - Templates
  - Channels
  - User preferences

---

## 🎯 9. **Implementation Strategy**

- [ ] Prioritize core flows (e.g., auth, signup, login, dashboard fetch)
- [ ] Parallelize dev work if team grows
- [ ] Start with vertical slices (feature per service)
- [ ] Use [Feature Toggles](https://martinfowler.com/articles/feature-toggles.html) for WIP features
- [ ] Implement test-first on critical paths

---

## 🧾 10. **Documentation & README**

- [ ] Per-service `README.md` with:

  - Purpose
  - How to run
  - How to test
  - Env vars

- [ ] Architecture overview in root `README.md` (linking C4 diagrams and ERDs)
- [ ] `docs/` folder for:

  - NFRs
  - ADRs (Architecture Decision Records)
  - API/Event contracts

---

## 📘 BONUS: Service Template (copy-paste ready)

Want a ready-to-go boilerplate for your services (e.g., NestJS + PostgreSQL + Kafka + Docker)? I can generate one for you, just tell me:

- Your preferred stack
- Dev tool preference (pnpm/Nx/Turborepo etc.)
- If you're using gRPC, REST, or both

---

Let me know if you want this turned into a **Kanban board**, **Notion table**, or CLI-based project scaffold — happy to go beyond checklist!
