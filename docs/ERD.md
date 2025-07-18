### AuthCredentialsDB (PostgreSQL)

- **Purpose**: Stores user credentials for authentication.
- **Schema**:
  - **Table: users**
    - `user_id` (UUID, PK): Unique user ID. Example: `123e4567-e89b-12d3-a456-426614174000` (John Doe).
    - `email` (VARCHAR): User email for login. Example: `john.doe@tenant.com`.
    - `password_hash` (VARCHAR): Hashed password (bcrypt). Example: `$2b$12$Kix2...`.
    - `mfa_secret` (VARCHAR, nullable): MFA secret key (TOTP). Example: `JBSWY3DPEHPK3PXP`, null if not enabled.
    - `created_at` (TIMESTAMP): Account creation time. Example: `2025-07-14 10:00:00`.
    - `last_login` (TIMESTAMP, nullable): Last login time. Example: `2025-07-14 15:30:00`, null if never logged in.
  - **Table: sessions**
    - `session_id` (UUID, PK): Unique session ID. Example: `987fcdeb-1234-5678-9012-34567890abcd`.
    - `user_id` (UUID, FK to `users.user_id`): Links to user. Example: `123e4567-e89b-12d3-a456-426614174000`.
    - `token` (VARCHAR): JWT/session token. Example: `eyJhbGciOiJIUzI1Ni...`.
    - `expires_at` (TIMESTAMP): Session expiration. Example: `2025-07-15 15:30:00`.

### RbacPolicyDB (PostgreSQL)

- **Purpose**: Stores roles and access policies for authorization.
- **Schema**:
  - **Table: roles**
    - `role_id` (UUID, PK): Unique role ID. Example: `456e7890-f12b-34c5-d678-901234567890` (“tenant_admin”).
    - `role_name` (VARCHAR): Role name. Example: `tenant_admin`.
    - `description` (TEXT, nullable): Role description. Example: “Manages tenant users and subscriptions.”
  - **Table: policies**
    - `policy_id` (UUID, PK): Unique policy ID. Example: `789a0123-b45c-67d8-e901-234567890123`.
    - `role_id` (UUID, FK to `roles.role_id`): Links to role. Example: `456e7890-f12b-34c5-d678-901234567890`.
    - `resource` (VARCHAR): Resource. Example: `website`.
    - `action` (VARCHAR): Action. Example: `write`.
    - `effect` (VARCHAR): Allow/deny. Example: `allow`.
  - **Table: user_roles**
    - `user_id` (UUID, FK to `AuthCredentialsDB.users.user_id`): Links to user. Example: `123e4567-e89b-12d3-a456-426614174000`.
    - `role_id` (UUID, FK to `roles.role_id`): Links to role. Example: `456e7890-f12b-34c5-d678-901234567890`.
    - Composite PK: `(user_id, role_id)`.

### ProfileDB (PostgreSQL)

- **Purpose**: Stores user profile information (non-sensitive).
- **Schema**:

  - **Table: user_profiles**

    - `user_id` (UUID, PK, FK to `AuthCredentialsDB.users.user_id`): User identifier.
    - `first_name` (VARCHAR): First name. Example: `Ahmed`.
    - `last_name` (VARCHAR): Last name. Example: `Benali`.
    - `profile_picture_url` (VARCHAR, nullable): Profile image. Example: `https://cdn.app.com/images/u1.png`.
    - `bio` (TEXT, nullable): Short biography or status. Example: `Full-stack developer & C++ enthusiast`.
    - `language` (VARCHAR, default `en`): Preferred language. Example: `fr`.
    - `created_at` (TIMESTAMP): Profile creation timestamp.

---

### **ApplicationDB (PostgreSQL)**

- **Purpose**: Tracks credit application lifecycle.
- **Schema**:

  - **Table: credit_applications**

    - `application_id` (UUID, PK)
    - `user_id` (UUID, FK → `AuthCredentialsDB.users.user_id`)
    - `status` (VARCHAR): `draft`, `submitted`, `approved`, etc.
    - `submitted_at` (TIMESTAMP)
    - `reviewed_by` (UUID, FK → `AuthCredentialsDB.users.user_id`, nullable): Admin reviewer.
    - `updated_at` (TIMESTAMP)

---

### ScoringCache (Redis)

- **Purpose**: Temporarily stores applicant scores, ranking, and derived data for fast access.
- **Structure**:

  - \*\*Key: \*\***`score:{applicant_id}`**

    - Value: JSON object with live scores.
      Example:

      ```json
      {
        "applicant_id": "abc123",
        "score": 87.5,
        "ranking": 12,
        "last_updated": "2025-07-17T13:00:00Z"
      }
      ```

  - \*\*Key: \*\***`leaderboard:{category}`**

    - Sorted Set of `(score, applicant_id)` used for quick leaderboard queries.

---

### CreditDataDB (PostgreSQL)

- **Purpose**: Stores normalized credit data fetched from 3rd-party providers.
- **Schema**:

  - **Table: credit_records**

    - `record_id` (UUID, PK): Unique record ID.
    - `user_id` (UUID, FK to `AuthCredentialsDB.users.user_id`): Applicant ID.
    - `provider` (VARCHAR): Source of data. Example: `Equifax`, `AlgeriaNationalBank`.
    - `raw_data` (JSONB): Original response (encrypted or masked).
    - `normalized_score` (INTEGER): Cleaned, scaled score. Example: `730`.
    - `status` (VARCHAR): `pending`, `processed`, `error`.
    - `retrieved_at` (TIMESTAMP): When the data was last pulled.

---

### DocumentStorage (S3-Compatible / PostgreSQL Metadata)

- **Purpose**: Handles secure file uploads (CVs, IDs, reports) and metadata.
- **Schema**:

  - **Table: documents**

    - `document_id` (UUID, PK): Unique file ID.
    - `user_id` (UUID, FK to `AuthCredentialsDB.users.user_id`): Owner.
    - `type` (VARCHAR): Document type. Example: `resume`, `national_id`, `transcript`.
    - `file_url` (VARCHAR): Full S3/MinIO URL. Example: `https://s3.local/documents/u1/resume.pdf`.
    - `content_type` (VARCHAR): MIME type. Example: `application/pdf`.
    - `uploaded_at` (TIMESTAMP): Upload timestamp.
    - `deleted` (BOOLEAN, default `false`): For soft deletes.

---

### NotificationDB (PostgreSQL)

- **Purpose**: Tracks notification logs, statuses, and user preferences.
- **Schema**:

  - **Table: notifications**

    - `notification_id` (UUID, PK): Unique ID.
    - `user_id` (UUID, FK): Who it's for.
    - `channel` (VARCHAR): `email` or `sms`.
    - `template_id` (UUID): Used template.
    - `status` (VARCHAR): `queued`, `sent`, `failed`.
    - `sent_at` (TIMESTAMP, nullable): Timestamp when sent.

  - **Table: templates**

    - `template_id` (UUID, PK): Template identifier.
    - `name` (VARCHAR): Template name. Example: `application_approved_email`.
    - `subject` (VARCHAR): For emails.
    - `body` (TEXT): Template body (Handlebars or similar syntax).
    - `channel` (VARCHAR): `email` or `sms`.

  - **Table: user_notification_preferences**

    - `user_id` (UUID, PK): User.
    - `channel` (VARCHAR, PK): Channel.
    - `enabled` (BOOLEAN): Example: `false` if user unsubscribed from SMS.

---

### ✅ Summary of Key Relationships Across Domains

| From                                    | Field                     | References           | Relationship                                                                | Description |
| --------------------------------------- | ------------------------- | -------------------- | --------------------------------------------------------------------------- | ----------- |
| `sessions.user_id`                      | → `users.user_id`         | Many-to-one (`*→1`)  | A session belongs to one user, a user can have many sessions                |             |
| `user_profiles.user_id`                 | → `users.user_id`         | One-to-one (`1→1`)   | Each user has one profile, and each profile belongs to one user             |             |
| `user_roles.user_id`                    | → `users.user_id`         | Many-to-many (`*↔*`) | A user can have many roles, and a role can be assigned to many users        |             |
| `user_roles.role_id`                    | → `roles.role_id`         | Many-to-one (`*→1`)  | A user-role record points to one role, each role can be assigned many times |             |
| `policies.role_id`                      | → `roles.role_id`         | Many-to-one (`*→1`)  | A role can have many policies attached to it                                |             |
| `credit_applications.user_id`           | → `users.user_id`         | One-to-many (`*→1`)  | A user can submit multiple credit applications                              |             |
| `credit_records.user_id`                | → `users.user_id`         | One-to-many (`*→1`)  | A user can have multiple credit records                                     |             |
| `documents.user_id`                     | → `users.user_id`         | One-to-many (`*→1`)  | A user can upload multiple documents                                        |             |
| `notifications.user_id`                 | → `users.user_id`         | One-to-many (`*→1`)  | A user can receive many notifications                                       |             |
| `notifications.template_id`             | → `templates.template_id` | Many-to-one (`*→1`)  | A notification uses one template; a template can be reused many times       |             |
| `user_notification_preferences.user_id` | → `users.user_id`         | One-to-many (`*→1`)  | A user can set preferences for multiple channels (email, SMS, etc.)         |             |
