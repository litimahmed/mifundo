---

### 📦 1. **Application Service** — "The Brain of the Credit Process"

#### ✅ What It Does

* Manages the **credit application lifecycle**.
* Stores application data (amount requested, term, reason, etc.).
* Tracks application **status**: draft → submitted → under review → approved/declined.

#### 💡 Real-Life Example

An applicant wants a loan of 300,000 DZD for a used car.

* They go to your web app.
* Fill out a form: employment details, income, loan amount.
* Hit "Submit."
* That data gets sent to the **Application Service**.
* It creates a new application, stores it in the DB, and triggers workflows like credit check, scoring, document verification.

#### 🧠 Think of it like:

> "The Trello board for each user's credit journey."

---

### 📦 2. **Scoring Service** — "The Decision Engine"

#### ✅ What It Does

- Takes user data (from Application Service + Credit Info).
- Applies **credit scoring algorithms** (e.g., risk assessment, decision trees, AI models).
- Outputs a score or decision (`APPROVE`, `REVIEW`, `DENY`).

#### 💡 Real-Life Example

Ahmed submits a loan application. The system checks:

- Salary: 90,000 DZD
- Existing debts: 1
- Credit history: clean
- Employment: full-time

The **Scoring Service** takes that, applies a scoring model, and says:

- Credit Score: 720
- Risk Level: Low
- Recommendation: APPROVE

This score gets attached to the application for review or auto-decisioning.

#### 🧠 Think of it like:

> "The AI judge behind every application."

---

### 📦 3. **Credit API Service** — "The External Eye"

#### ✅ What It Does

- Talks to **third-party credit bureaus** or national credit registries.
- Fetches external credit history (debts, defaults, missed payments).
- Normalizes inconsistent API responses for internal use.

#### 💡 Real-Life Example

The Scoring Service wants to check if Ahmed has ever defaulted on a telecom bill.

- It calls the **Credit API Service**.
- That service sends a request to an external API like:

  ```
  GET https://algerian-credit-registry.gov/api/credit-history?national_id=0123456789
  ```

- Parses the response and returns:

  ```json
  {
    "debts": 0,
    "defaults": 0,
    "score_from_registry": 680
  }
  ```

#### 🧠 Think of it like:

> "The middleman that fetches truth from outside the walls."

---

### 📦 4. **Document Service** — "The Paper Pusher"

#### ✅ What It Does

- Handles upload, download, and storage of sensitive documents:

  - ID card
  - Salary slips
  - Proof of employment
  - Bank statements

- Securely stores them (e.g., Amazon S3, MinIO).

#### 💡 Real-Life Example

Ahmed uploads:

- His national ID
- His last 3 pay slips

The front-end app sends files to the **Document Service**, which:

- Validates them (e.g., type, size).
- Tags them (linked to application ID).
- Stores them securely (e.g., S3 bucket: `loan-apps/app_4567/docs/`).
- Provides a secure link for the officer to review later.

#### 🧠 Think of it like:

> "The digital filing cabinet for your platform."

---
