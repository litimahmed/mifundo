workspace {

  model {
    // Actors
    applicant = person "Applicant" "End user applying for credit"
    creditOfficer = person "Credit Officer" "Reviews credit applications"
    admin = person "Admin" "Manages system configuration and users"

    // Frontend System
    frontend = softwareSystem "Web App (Angular SPA)" "Frontend used by applicants, officers, and admins" {
      tags "platform"
    }

    // Core Microservice Backend
    backend = softwareSystem "Core Backend (Microservices)" "Domain-aligned microservices handling business logic" {
      tags "platform"

      group "Authentication Service" {
        authService = container "Authentication Service" "Handles login and JWT issuance" "Node.js/NestJS" {
          tags "internal"
        }
        authDb = container "Auth DB" "Stores users, hashed passwords, sessions" "PostgreSQL" {
          tags "database"
        }
        authService -> authDb "Reads/Writes" "SQL"
      }

      group "Authorization Service" {
        rbacService = container "Authorization Service" "Manages roles and permissions" "Node.js/NestJS" {
          tags "internal"
        }
        rbacDb = container "RBAC DB" "Stores role/permission mappings" "PostgreSQL" {
          tags "database"
        }
        rbacService -> rbacDb "Reads/Writes" "SQL"
      }

      group "Profile Service" {
        profileService = container "Profile Service" "Manages applicant profiles" "Node.js/NestJS" {
          tags "internal"
        }
        profileDb = container "Profile DB" "Stores user profile info" "PostgreSQL" {
          tags "database"
        }
        profileService -> profileDb "Reads/Writes" "SQL"
      }

      group "Application Service" {
        applicationService = container "Application Service" "Handles credit application lifecycle" "Node.js/NestJS" {
          tags "internal"
        }
        applicationDb = container "Application DB" "Stores applications and workflow states" "PostgreSQL" {
          tags "database"
        }
        applicationService -> applicationDb "Reads/Writes" "SQL"
      }

      group "Document Service" {
        documentService = container "Document Service" "Handles file uploads/downloads" "Node.js/NestJS" {
          tags "internal"
        }
        // No local DB, external S3
      }

      group "Credit API Service" {
        creditApiService = container "Credit API Service" "Fetches/normalizes credit data" "Node.js/NestJS" {
          tags "internal"
        }
      }

      group "Scoring Service" {
        scoringService = container "Scoring Service" "Calculates credit score" "Python" {
          tags "internal"
        }
        redis = container "Redis Store" "Caches scoring results" "Redis" {
          tags "database"
        }
        scoringService -> redis "Reads/Writes" "Redis"
      }

      group "Notification Service" {
        notificationService = container "Notification Service" "Sends alerts/emails/SMS" "Node.js/NestJS" {
          tags "internal"
        }
      }

      group "Monitoring Agent" {
        monitoringAgent = container "Monitoring Agent" "Pushes metrics/logs" "Prometheus Node Exporter" {
          tags "internal"
        }
      }
    }

    // External Systems
    eid = softwareSystem "eID Provider" "Verifies applicant identity" {
       tags "external" 
       }
    creditApi = softwareSystem "Credit Info API" "Fetches credit history" {
       tags "external"
        }
    emailService = softwareSystem "Email Provider" "Delivers system emails" {
       tags "external" 
       }
    storage = softwareSystem "S3 Bucket" "Stores applicant documents" {
       tags "external" 
       }
    monitoring = softwareSystem "Monitoring System" "Aggregates logs/metrics" {
       tags "external" 
       }

    // Relationships
    applicant -> frontend "Uses"
    creditOfficer -> frontend "Uses"
    admin -> frontend "Uses"

    frontend -> authService "Login via" "HTTP/REST"
    frontend -> profileService "Profile CRUD" "HTTP/REST"
    frontend -> applicationService "Submit Applications" "HTTP/REST"
    
    authService -> rbacService "Permission check" "HTTP/gRPC"
    authService -> eid "Verify identity" "HTTP/REST"

    applicationService -> documentService "Upload files" "HTTP/REST"
    documentService -> storage "Store in S3" "HTTP/REST"

    applicationService -> creditApiService "Fetch credit data" "HTTP/REST"
    creditApiService -> creditApi "Query data" "HTTP/REST"

    applicationService -> scoringService "Score request" "HTTP/gRPC"
    scoringService -> creditApiService "Credit data fetch" "HTTP/gRPC"
    scoringService -> redis "Cache results" "Redis"

    notificationService -> emailService "Send email" "SMTP/HTTP"
    monitoringAgent -> monitoring "Forward logs/metrics" "Prometheus PushGateway"
  }

  views {
    container backend {
      include *
      autoLayout lr
      title "Backend Container View – Microservice Architecture"
      description "Each microservice is grouped with its database and communication protocols are specified"
    }

    styles {
      element "Person" {
        shape person
        background #0ED2D8
        color #ffffff
      }

      element "platform" {
        shape Folder
        background #d6f0ff
        stroke #057276
        strokeWidth 7
      }

      element "internal" {
        shape hexagon
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }

      element "external" {
        shape RoundedBox
        background #FFE8E0
        stroke #E76F51
        color #E76F51
        strokeWidth 6
      }

      element "database" {
        shape cylinder
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
    }
  }
}
