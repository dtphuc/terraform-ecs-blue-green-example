variable "create_ecr_repository" {
  description = "Controls if ECS should be created"
  type        = bool
  default     = true
}

variable "repo_name" {
  description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
  type        = list(string)
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
}

variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = any
  })
  description = "ECR encryption configuration"
  default     = null
}

variable "scan_images_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not (false)"
  default     = false
}

variable "tags" {
  description = "A map of tags to add to ECS Cluster"
  type        = map(string)
  default     = {}
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
  default     = true
}

variable "enable_ecr_policy" {
  type        = string
  description = "Whether to enable ECR Repository Policy"
}

variable "enable_full_access" {
  type        = string
  description = "Whether to use Full Admin Permission"
}

variable "enable_readonly_access" {
  type        = string
  description = "Whether to use ReadOnly Permission"
}

variable "principals_full_access" {
  type        = string
  description = "Principal ARNs to provide with full access to the ECR"
  default     = ""
}

variable "principals_read_only" {
  type        = string
  description = "Principal ARNs to provide with readonly access to the ECR"
  default     = ""
}




