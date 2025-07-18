workspace {

  model {
    user = person "Applicant"{
        tag "Person"
    }
    admin = person "Admin"{
        tag "Person"
    }

    system = softwareSystem "Document Service" {
      tags "Service"

      Container_API = container "Document Controller" {
        technology "NestJS"
        description "Handles HTTP requests for uploading, retrieving, and managing documents"
        tags "internal"
      }

      Container_DocumentService = container "Document Management Service" {
        technology "NestJS Service"
        description "Coordinates storage, metadata, and access control"
        tags "internal"
      }

      Container_StorageAdapter = container "Storage Adapter" {
        technology "AWS SDK / Local FS / S3 Driver"
        description "Abstracts the underlying file storage (S3, local disk, etc.)"
        tags "database"
      }

      Container_MetadataRepo = container "Metadata Repository" {
        technology "TypeORM / Prisma"
        description "Handles metadata persistence like filenames, types, owners, upload dates"
        tags "database"
      }

      Container_DTOs = container "DTOs" {
        technology "TypeScript Interfaces"
        description "Data Transfer Objects for input validation and response shaping"
        tags "internal"
      }

      Container_Guards = container "Guards" {
        technology "NestJS Guards"
        description "Ensure only authorized users access protected document routes"
        tags "internal"
      }

      Container_Interceptors = container "Interceptors" {
        technology "NestJS Interceptors"
        description "Used for logging, response formatting, or upload progress tracking"
        tags "internal"
      }

      Container_ExceptionFilters = container "Exception Filters" {
        technology "NestJS Filters"
        description "Custom error handlers for common document-related errors"
        tags "internal"
      }

      // Relationships
      user -> Container_API "Uploads/Fetches document"
      admin -> Container_API "Manages documents"

      Container_API -> Container_DocumentService "Delegates logic"
      Container_DocumentService -> Container_StorageAdapter "Stores files"
      Container_DocumentService -> Container_MetadataRepo "Stores metadata"
      Container_API -> Container_DTOs "Validates input/output"
      Container_API -> Container_Guards "Protects routes"
      Container_API -> Container_Interceptors "Applies formatting, logging"
      Container_API -> Container_ExceptionFilters "Handles exceptions"
    }
  }

  views {
    container system {
      include *
      autolayout lr
      title "System Context - Document Service"
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
