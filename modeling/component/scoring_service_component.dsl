workspace {

  model {
    user = person "Credit Officer"

    scoring = softwareSystem "Scoring Service" {
      tags "Service"

      scoring_api = container "Scoring API" {
        technology "FastAPI + Uvicorn"
        tags "internal"
        description "Handles HTTP requests related to scoring."
      }

      scoring_service = container "Scoring Logic Service" {
        technology "Python Module"
        tags "internal"
        description "Core business logic for credit scoring."
      }

      repository = container "Scoring Repository" {
        technology "SQLAlchemy + PostgreSQL"
        tags "internal"
        description "Data access layer for storing/retrieving scores."
      }

      dto = container "Scoring DTOs" {
        technology "Pydantic"
        tags "internal"
        description "Input/output schemas used for data validation and serialization."
      }

      redis_queue = container "Task Queue" {
        technology "Redis"
        tags "queue"
        description "Used by Celery for async scoring tasks."
      }

      worker = container "Scoring Worker" {
        technology "Celery Worker"
        tags "internal"
        description "Processes async scoring jobs from Redis queue."
      }

      exception_handler = container "Global Exception Handler" {
        technology "FastAPI Middleware"
        tags "internal"
        description "Handles application-wide exceptions and error responses."
      }

      interceptor = container "Request Logging Interceptor" {
        technology "Custom Middleware"
        tags "internal"
        description "Logs all incoming requests and scoring decisions."
      }

      // Relationships
      user -> scoring_api "Initiates scoring request"
      scoring_api -> dto "Validates and parses input data"
      scoring_api -> scoring_service "Delegates scoring operation"
      scoring_service -> repository "Reads and writes score data"
      scoring_api -> redis_queue "Pushes async jobs"
      worker -> redis_queue "Consumes scoring jobs"
      worker -> scoring_service "Executes scoring logic"
      scoring_service -> repository "Persists scores"
      scoring_api -> exception_handler "Delegates error handling"
      scoring_api -> interceptor "Intercepts request for logging"
    }
  }

  views {
    container scoring {
      include *
      autolayout lr
      title "Scoring Service — Component Diagram"
    }

    styles {
      element "External" {
        background #999999
        color white 
      }
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
      element "queue" {
        shape Cylinder
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
    }
  }
}
