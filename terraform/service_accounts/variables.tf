variable "service_accounts" {
  type = map(any)
  default = {
    "serviceaccount1" : {
      display_name = "Service Account 1"
      roles        = ["roles/viewer", "roles/bigquery.dataEditor"]
    }
    "serviceaccount2" : {
      display_name = "Service Account 2"
      roles        = ["roles/viewer", "roles/bigquery.connectionUser"]
    }
    "serviceaccount3" : {
      display_name = "Service Account 3"
      roles        = ["roles/viewer", "roles/bigquery.dataViewer"]
    }
    "serviceaccount4" : {
      display_name = "Service Account 4"
      roles        = ["roles/viewer", "roles/run.invoker"]
    }
    "cloud-functions-app-sa" : {
      display_name = "SA For Cloud Function Zipper App"
      roles = ["roles/viewer",
        "roles/cloudfunctions.developer",
        "roles/eventarc.eventReceiver",
        "roles/pubsub.publisher",
        "roles/pubsub.subscriber",
        "roles/iam.serviceAccountUser"
      ]
    }
  }
}

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

        # "roles/storage.admin",
        # "roles/storage.objectAdmin"