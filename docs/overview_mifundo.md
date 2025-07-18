---

## ✅ **Actors**

These are the key human or system actors interacting with the platform:

1. **Applicant** – the user applying for cross-border credit.
2. **Credit Officer** – a bank or institution agent reviewing applications.
3. **Admin** – internal platform administrator managing configuration, users, etc.
4. **Third-party Financial Institutions** – external banks or credit data providers (via APIs).
5. **Government or EU Authority API** – for verifying identity or creditworthiness cross-border.

---

## ✅ **Core Backend Services (Modules)**

We’ll keep this monolithic, but **logically modular**, with DDD-style service boundaries:

### 1. **Auth Service**

- Handles registration, login, logout
- Issues JWT (tenant-aware, role-based)
- Manages refresh tokens

### 2. **User & Profile Management**

- Stores applicant profiles and supporting details (address, employment, etc.)
- Updates user info

### 3. **RBAC (Roles & Permissions)**

- Defines roles: `applicant`, `officer`, `admin`
- Controls access to protected routes and features

### 4. **Application Submission**

- Applicants submit credit applications
- Upload required documents
- Track application status

### 5. **Document Handling**

- Upload/download personal and financial documents securely
- Storage abstraction (local or cloud)

### 6. **Credit Score Integration**

- Talks to 3rd-party APIs to fetch applicant credit data (Estonia, EU zone)
- Handles errors, retries, and aggregation

### 7. **Application Review & Decisioning**

- Interface for Credit Officers to:

  - View applications
  - Leave notes/comments
  - Approve/reject with reasoning

### 8. **Notifications**

- In-app & email notifications:

  - Status updates
  - New document requests
  - Approval/rejection

### 9. **Audit Logging**

- Tracks sensitive actions (decision-making, login events, changes)

### 10. **Admin Console / Configuration**

- Manage user roles, platform settings, and view system metrics

---

## ✅ **External Services / APIs**

These are outside the monolith and must be integrated:

1. **Estonian/eID or EU Digital ID Verification APIs**
2. **Banking/Credit APIs (like CreditInfo, Krediidiinfo)**
3. **Email Service (SMTP or provider like Mailgun/SendGrid)**
4. **Cloud Document Storage (optional: AWS S3, Firebase Storage)**
5. **Monitoring Tools (Sentry, Prometheus, etc.)**
6. **PDF generation for application summaries or exports (Node service or library)**

---
