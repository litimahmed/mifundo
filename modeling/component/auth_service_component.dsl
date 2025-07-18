workspace {

  model {
    user = person "End User" "Logs into the platform"

    authService = softwareSystem "Authentication Service" "Handles user authentication, token issuance, and session management" "Node.js + NestJS"{

    // Core Components
    controller = container "AuthController" "Manages login, register, logout, refresh endpoints"{
        tags "internal"
    }
    service = container "AuthService" "Contains auth logic, session, password, JWT handling"{
        tags "internal"
    }
    userRepo = container "UserRepository" "Handles user persistence"{
        tags "internal"
    }
    sessionRepo = container "SessionRepository" "Manages refresh sessions"{
        tags "internal"
    }
    tokenService = container "TokenService" "Generates and validates JWTs"{
        tags "internal"
    }

    // Security & Lifecycle
    guard = container "JwtAuthGuard" "Protects endpoints using JWT validation"{
        tags "internal"
    }
    strategy = container "JwtStrategy" "Extracts and validates JWT payload"{
        tags "internal"
    }
    hasher = container "PasswordHasher" "Hashes & compares passwords securely"{
        tags "internal"
    }

    // Infrastructure Support
    dto = container "AuthDTOs" "Shapes login, register, refresh request/response"{
        tags "internal"
    }
    filter = container "AuthExceptionFilter" "Handles invalid credentials or token errors"{
        tags "internal"
    }
    interceptor = container "AuthLoggingInterceptor" "Logs auth-related actions"{
        tags "internal"
    }
    decorator = container "CurrentUserDecorator" "Injects the currently logged-in user"{
        tags "internal"
    }

    db = container "AuthDB" "Stores user, session, and token data" "PostgreSQL"{
        tags "database"
    }
    }
    // Relationships
    user -> controller "Sends auth requests"
    controller -> dto "Uses DTOs for request validation"
    controller -> guard "Guards protected routes"
    controller -> decorator "Injects current user"
    controller -> service "Delegates logic"
    controller -> filter "Handles exceptions"
    controller -> interceptor "Logs requests"
    
    guard -> strategy "Uses strategy to validate token"
    strategy -> tokenService "Parses JWT"
    
    service -> userRepo "Fetches user"
    service -> sessionRepo "Creates/manages refresh sessions"
    service -> tokenService "Generates access/refresh tokens"
    service -> hasher "Verifies passwords"
    
    userRepo -> db "Reads/writes user data"
    sessionRepo -> db "Reads/writes sessions"
  }

  views {
    container authService {
      include *
      autolayout lr
      title "Component Diagram - Authentication Service (NestJS)"
      description "Detailed component structure of the Authentication Service using NestJS standards"
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
