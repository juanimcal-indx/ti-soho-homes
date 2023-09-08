variable "project_id" {
  type     = string
  nullable = false
  default  = "arboreal-parser-236919"
}

variable "gcp_region" {
  type     = string
  nullable = false
  default  = "europe-southwest1"
}

variable "gcp_zone" {
  type     = string
  nullable = false
  default  = "europe-southwest1-a"
}

variable "cloud_function_sa" {
  type     = string
  nullable = false
  default  = "cloud-functions-app-sa@arboreal-parser-236919.iam.gserviceaccount.com"
}

variable "cloud_storage_sa" {
  type     = string
  nullable = false
  default  = "service-688958502112@gs-project-accounts.iam.gserviceaccount.com"
}
