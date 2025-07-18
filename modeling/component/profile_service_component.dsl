workspace {

  model {
    user = person "End User" "Manages their own profile data"

    profileService = softwareSystem "Profile Service" "Handles user profile creation, updates, and retrieval" "Node.js + NestJS"{

    // Core Components
    controller = container "ProfileController" "Exposes endpoints like GET /me, PUT /profile"{
        tags "internal"
    }
    service = container "ProfileService" "Contains business logic for profile updates and access"{
        tags "internal"
    }
    repo = container "ProfileRepository" "Handles database operations for profile entities"{
        tags "internal"
    }

    // Infrastructure
    dto = container "ProfileDTOs" "Shapes the request/response payloads"{
        tags "internal"
    }
    guard = container "JwtAuthGuard" "Protects routes using user authentication"{
        tags "internal"
    }
    interceptor = container "ProfileLoggingInterceptor" "Logs profile access and update events"{
        tags "internal"
    }
    decorator = container "CurrentUserDecorator" "Injects user info into handlers"{
        tags "internal"
    }
    pipe = container "ValidationPipe" "Validates and transforms incoming data"{
        tags "internal"
    }
    filter = container "ProfileExceptionFilter" "Handles errors like profile not found or validation errors"{
        tags "internal"
    }

    db = container "ProfileDB" "Stores user profile information" "PostgreSQL"{
        tags "database"
    }

    // Relationships
    user -> controller "Calls endpoints to manage profile"
    controller -> dto "Uses DTOs for shape & validation"
    controller -> guard "Secures endpoints"
    controller -> decorator "Injects current user"
    controller -> pipe "Validates input"
    controller -> service "Delegates to service"
    controller -> filter "Catches errors"
    controller -> interceptor "Logs actions"

    service -> repo "Reads/writes profiles"
    repo -> db "Interacts with database"
    }
  }

  views {
    container profileService {
      include *
      autolayout lr
      title "Component Diagram - Profile Service (NestJS)"
      description "Clean architecture components of the Profile Service with NestJS conventions"
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
