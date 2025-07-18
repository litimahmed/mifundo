| Actor              | Microservice                  | Responsibilities                               |
| ------------------ | ----------------------------- | ---------------------------------------------- |
| **Applicant**      | `ApplicationService`          | Submit application, check status               |
|                    | `ProfileService`              | Manage personal info, documents                |
|                    | `NotificationService`         | Receive updates                                |
|                    | `IdentityService`             | Register, login, token handling                |
|                    | `ScoringService`              | (Indirectly) triggers credit score calculation |
| **Credit Officer** | `ReviewService`               | View/review applications, assign status        |
|                    | `DocumentVerificationService` | Verify uploaded documents                      |
|                    | `AuditService` (read-only)    | Track decision logs                            |
| **Admin**          | `UserManagementService`       | Manage platform users (officers, applicants)   |
|                    | `AccessControlService`        | Define and enforce RBAC policies               |
|                    | `ConfigurationService`        | Modify system thresholds, scoring rules        |
|                    | `MonitoringService`           | Observe system health, logs, metrics           |
