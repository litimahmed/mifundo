workspace {

  model {
    user = person "Credit Officer"{
        tags "person"
    }

    system = softwareSystem "Credit API Service" {
      tags "Service"

     

      Component_Controller = container "CreditController" {
        technology "NestJS Controller"
        tags "internal"
        description "REST endpoint to request and return normalized credit data"
      }

      Component_Service = container "CreditService" {
        technology "NestJS Service"
        tags "internal"
        description "Coordinates fetching, parsing, and normalization logic"
      }

      Component_Repository = container "CreditRepository" {
        technology "NestJS Repository"
        tags "internal"
        description "Optional: Local cache or historical storage access"
      }

      Component_Interceptor = container "LoggingInterceptor" {
        technology "NestJS Interceptor"
        tags "internal"
        description "Logs requests/responses for observability"
      }

      Component_Guard = container "AuthGuard" {
        technology "NestJS Guard"
        tags "internal"
        description "Ensures internal-only access"
      }

      Component_DTO = container "CreditDTOs" {
        technology "TypeScript Classes"
        tags "internal"
        description "Request/Response DTOs for validation and shaping"
      }

      Component_Filter = container "HttpExceptionFilter" {
        technology "NestJS Exception Filter"
        tags "internal"
        description "Handles thrown exceptions and returns friendly API errors"
      }

      // Relationships
      user -> Component_Controller "Requests applicant credit report"
      Component_Controller -> Component_Guard "Checks auth"
      Component_Controller -> Component_Interceptor "Intercepts request/response"
      Component_Controller -> Component_DTO "Validates input/output"
      Component_Controller -> Component_Service "Delegates credit processing"
      Component_Service -> Component_Repository "Accesses storage/cache"
      Component_Service -> Component_DTO "Shapes data model"
      Component_Service -> Component_Filter "Handles exceptions"

    
  }
  }

  views {
    container system {
      include *
      autolayout lr
      title "Credit API Service - Component View"
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
    }
  }
}
