workspace {

  model {
    user = person "Applicant" {
      description "A user applying for a cross-border credit."
    }

    officer = person "Credit Officer" {
      description "A bank or institution representative reviewing and deciding on credit applications."
    }

    admin = person "Platform Admin" {
      description "An internal admin who manages users, settings, and system configurations."
    }

    system = softwareSystem "Credit Application Platform" {
      description "A web platform that enables users to apply for cross-border credit and allows financial institutions to review applications."
        tags "platform"
      user -> this "Submits credit applications and tracks their status"
      officer -> this "Reviews and manages credit applications"
      admin -> this "Manages users and system configuration"

      container_api = container "Web Application (Angular Frontend)" {
        technology "Angular"
        description "The frontend SPA used by all user roles."
        tags "internal"
      }

      container_backend = container "Backend Service (Monolithic)" {
        technology "Node.js / NestJS"
        description "Handles all business logic"
        tags "internal"
      }

      user -> container_api "Uses"
      officer -> container_api "Uses"
      admin -> container_api "Uses"
      container_api -> container_backend "Calls API"

      // External systems
      eid = container "eID / EU Identity Provider" {
        description "External service for verifying digital identity of the applicant."
        tags "external"
      }

      creditApi = container "Credit Info Provider (e.g. CreditInfo, Krediidiinfo)" {
        description "Used to fetch applicant credit scores and financial history."
        tags "external"
      }

      emailService = container "Email Service Provider" {
        description "Sends email notifications to users (e.g. Mailgun, SendGrid)."
        tags "external"
      }

      storage = container "Document Storage" {
        description "Stores uploaded documents securely (e.g. AWS S3, Firebase Storage)."
        tags "external"
      }

      monitoring = container "Monitoring & Logging Platform" {
        description "Used for performance metrics and application error tracking (e.g. Sentry, Prometheus)."
        tags "external"
      }

      container_backend -> eid "Verifies applicant identity using"
      container_backend -> creditApi "Fetches credit information from"
      container_backend -> emailService "Sends emails via"
      container_backend -> storage "Stores documents in"
      container_backend -> monitoring "Sends logs and metrics to"
    }
  }

  views {
    systemContext system {
      include *
      autolayout tb
      title "System Context - Credit Application Platform"
      description "High-level overview showing users and external systems interacting with the credit application platform."
    }
      container system {
        include *
        autoLayout tb
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
        color #003049
                background #d6f0ff
                stroke #057276
                strokeWidth 7
                shape hexagon
      }                                  

      element "external" {
         color #E76F51
                background #FFE8E0
                stroke #E76F51
                strokeWidth 6
                shape RoundedBox
      }

    //   relationship {
    //     thickness 2
    //     color #64748b
    //   }
    }
  }
}
