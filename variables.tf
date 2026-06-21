variable "terraform" {
    type= map(any)
    default = {}
}

variable "compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}
variable "security_group" {
  default = {}
}

variable "application" {}


variable "codebuild_image" {
  default = "aws/codebuild/standard:6.0"
  type= string
  validation {
    condition = can(regex(":[6-9].\\d", var.codebuild_image))
    error_message = "The codebuild image should be v6 or higher"
  }
}

variable "arm64_codebuild_image" {
    default = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    validation {
    condition = can(regex(":[3-9].\\d", var.arm64_codebuild_image))
    error_message = "The codebuild image should be v3 or higher"
  }
}

variable "standard_image" {
  default = true
}

variable "codebuild_type" {}
variable "priviliged" {}

variable "codebuild_build_timeout" {
  default = "120"
  description = "build custom timeout, defualt to 2 hours"
}


variable "source_type" {
    type = string
    default = "GITHUB_ENTERPRISE"
  validation {
    condition = contains(["GITHUB_ENTERPRISE","S3","NO_SOURCE"],var.source_type)
    error_message = "variable type must be GITHUB_ENTERPRISE,S3,NO_SOURCE."
  }
}


variable "github_repo" {}
variable "clone_depth" {}
variable "filters" {
  type = list(any)
  default = []
}


variable "pat_secret_arn" {
  type = string
}

variable "github_repo_name" {}
variable "webhook_events" {
    default = ["push"]
}

variable "webhook_active" {
    default = true
}

variable "enable_customl_role_policy" {}

variable "enable_customl_trust_policy" {
  default = false
}


variable "iam_managed_policy_arns" {
  default = []
  type = list(string)
}

variable "s3_bucket" {
  default = ""
}

variable "artifact_type" {
  default = "s3"
  description = "Build output artifact's type. valid values: CODEPIPELINE,NO_ARTFACTS,S3"
}

variable "cache_type" {
  description = "Valid values No_cache, Local, S3"
  default = "S3"
  validation {
    condition = contains(["NO_CACHE","S3","LOCAL"],var.cache_type)
    error_message = "cache type must be one of:NO_CACHE,S3,LOCAL"
  }
}

variable "region" {}

variable "tags" {
  default = {}
}

variable "artifact_path" {
  default ={}
}

variable "artifact_packaging" {
  default = "NONE"
}

variable "environment_variables" {
  type = map(any)
}
