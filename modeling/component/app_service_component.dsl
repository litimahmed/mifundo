workspace {

  model {
    user = person "Applicant" "Submits loan applications"
    
    applicationService = softwareSystem "Application Service" "Handles credit application lifecycle" "Node.js + NestJS"{

    // Components
    controller = container "ApplicationController" "Handles HTTP requests (e.g. submit, fetch status)"{
        tags "internal"
    }
    service = container "ApplicationService" "Business logic for application handling"{
        tags "internal"
    }
    repo = container "ApplicationRepository" "Handles persistence to the DB"{
        tags "internal"
    }

    dto = container "ApplicationDTOs" "Defines data shape for create/update ops"{
        tags "internal"
    }
    guard = container "RolesGuard" "Restricts access based on user roles"{
        tags "internal"
    }
    pipe = container "ValidationPipe" "Validates and transforms request payloads"{
        tags "internal"
    }
    filter = container "HttpExceptionFilter" "Custom error handling"{
        tags "internal"
    }
    interceptor = container "LoggingInterceptor" "Logs request/response cycle"{
        tags "internal"
    }
    decorator = container "CurrentUserDecorator" "Extracts user info from request"{
        tags "internal"
    }

    db = container "ApplicationDB" "Stores credit applications" "PostgreSQL"{
        tags "database"
    }
    }
    // Relationships
    user -> controller "Sends HTTP requests"
    controller -> guard "Checks user role"
    controller -> pipe "Validates input DTO"
    controller -> decorator "Injects current user"
    controller -> service "Delegates business logic"
    controller -> interceptor "Intercepts requests"
    controller -> filter "Handles thrown exceptions"
    service -> repo "Reads/writes data"
    service -> dto "Uses DTOs to structure data"
    repo -> db "Persists application data"
  }

  views {
    container applicationService {
      include *
      autolayout lr
      title "Component Diagram - Application Service (NestJS)"
      description "Details the internal structure of the Application Service following NestJS standards"
    }

    styles {
      element "Person" {
        shape person
        background #06B3DE
        color #ffffff
      }

      

      element "internal" {
        shape RoundedBox
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
      element "database" {
        shape Cylinder
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
    }
  }
}
