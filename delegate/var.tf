variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-central1"
}

variable "harness_delegate_token" {
  description = "Harness Delegate token"
  type        = string
}

variable "harness_account_id" {
  description = "Harness Account ID"
  type        = string
}

variable "harness_delegate_name" {
  description = "Name for the Harness Delegate"
  type        = string
  default     = "cloudrun-delegate"
}
