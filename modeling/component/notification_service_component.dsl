workspace {

  model {
    admin = person "Admin"{
        tag "person"
    }
    applicant = person "Applicant"{
        tag "person"
    }
    system = softwareSystem "Notification Service" {
      tags "Service"

      Container_NotificationController = container "Notification API" {
        technology "NestJS Controller"
        description "Exposes limited API for managing notification templates or testing delivery (admin-only)"
        tags "internal"
      }

      Container_NotificationService = container "Notification Service" {
        technology "NestJS Service"
        description "Core logic that processes events, loads templates, and triggers channel-specific providers"
        tags "internal"
      }

      Container_EventConsumer = container "Event Consumer" {
        technology "NestJS Listener / Kafka Consumer"
        description "Listens to domain events (e.g., user registered, document uploaded) from Kafka or Redis Streams"
        tags "internal"
      }

      Container_TemplateEngine = container "Template Engine" {
        technology "Handlebars / Nunjucks"
        description "Processes dynamic templates for email, SMS, push, etc."
        tags "internal"
      }

      Container_EmailProvider = container "Email Provider" {
        technology "Nodemailer / SMTP / Mailgun SDK"
        description "Sends email via SMTP or third-party service"
        tags "internal"
      }

      Container_SMSProvider = container "SMS Provider" {
        technology "Twilio SDK / Provider Wrapper"
        description "Sends SMS through Twilio or another service"
        tags "internal"
      }

      Container_NotificationRepo = container "Notification Repository" {
        technology "Prisma / TypeORM"
        description "Stores notification logs, delivery attempts, user preferences"
        tags "database"
      }

      // Relations
     applicant -> Container_NotificationController "Can view or fetch their notifications (limited)"

admin -> Container_NotificationController "Manages notification templates, tests delivery"

Container_NotificationController -> Container_NotificationService "Delegates notification logic"

Container_NotificationController -> Container_NotificationRepo "Reads/writes logs or templates"

Container_NotificationService -> Container_TemplateEngine "Processes templates"
Container_NotificationService -> Container_EmailProvider "Sends email"
Container_NotificationService -> Container_SMSProvider "Sends SMS"
Container_NotificationService -> Container_NotificationRepo "Stores logs and preferences"

Container_EventConsumer -> Container_NotificationService "Passes incoming events"
    }
  }

  views {
    container system {
      include *
      autolayout lr
      title "System Context - Notification Service"
    }


    styles {
     element "internal" {
        shape RoundedBox
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
      element "Person" {
        shape person
        background #06B3DE
        color #ffffff
      }
      element "database"{
        shape Cylinder
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
    }
  }
}
