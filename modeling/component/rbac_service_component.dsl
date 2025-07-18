workspace {

  model {
    user = person "Admin " "Manages user roles and permissions"

    rbacService = softwareSystem "RBAC Service" "Handles roles, permissions, and access checks" "Node.js + NestJS"{

    // Core Components
    controller = container "RbacController" "Endpoints like GET /roles, POST /permissions"{
        tags "internal"
    }
    service = container "RbacService" "Business logic for role/permission assignment and checks"{
        tags "internal"
    }
    repo = container "RbacRepository" "Data access layer for roles, permissions, bindings"{
        tags "internal"
    }

    // Supporting containers
    dto = container "RbacDTOs" "Defines input/output shapes"{
        tags "internal"
    }
    guard = container "RolesGuard" "Restricts access based on user roles"{
        tags "internal"
    }
    interceptor = container "AuditInterceptor" "Logs permission-related operations"{
        tags "internal"
    }
    pipe = container "ValidationPipe" "Validates incoming data"{
        tags "internal"
    }
    filter = container "RbacExceptionFilter" "Handles forbidden access, missing roles, etc."{
        tags "internal"
    }
    decorator = container "RolesDecorator" "Custom decorator to tag handlers with required roles"{
        tags "internal"
    }

    db = container "RbacDB" "Stores roles, permissions, and mappings" "PostgreSQL"{
        tags "database"
    }
    }
    // Relationships
    user -> controller "Assigns roles, checks access"
    controller -> dto "Uses DTOs for validation/serialization"
    controller -> pipe "Validates input"
    controller -> guard "Protects endpoints by role"
    controller -> decorator "Decorates handlers with role requirements"
    controller -> filter "Handles errors"
    controller -> interceptor "Logs access attempts"
    controller -> service "Delegates logic"

    service -> repo "Fetches and updates roles/permissions"
    repo -> db "Reads/writes to RBAC schema"
  }

  views {
    container rbacService {
      include *
      autolayout lr
      title "Component Diagram - RBAC Service (NestJS)"
      description "Clean architecture of the RBAC Service for managing roles and permissions"
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
