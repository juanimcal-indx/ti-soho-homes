data "archive_file" "source_code" {
  type        = "zip"
  source_dir = "${path.module}/../../src/zipper-function/"
  output_path = "${path.module}/tmp/zipper.zip"
}

resource "google_storage_bucket" "deploy" {
  name          = "deploy-${var.project_id}"
  location      = var.gcp_region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "source" {
  name          = "source-${var.project_id}"
  location      = var.gcp_region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "dest" {
  name          = "dest-${var.project_id}"
  location      = var.gcp_region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "source_perms" {
  bucket = resource.google_storage_bucket.source.name
  role = "roles/storage.objectUser"
  member = "serviceAccount:${var.cloud_function_sa}"
}

resource "google_storage_bucket_iam_member" "dest_perms" {
  bucket = resource.google_storage_bucket.dest.name
  role = "roles/storage.objectUser"
  member = "serviceAccount:${var.cloud_function_sa}"
}

resource "google_storage_bucket_object" "upload_src" {
  name   = "zipper.zip"
  source = data.archive_file.source_code.output_path
  bucket = resource.google_storage_bucket.deploy.name
}

resource "google_project_iam_member" "storage_binding" {
  project  = var.project_id
  role     = "roles/pubsub.publisher"
  member   = "serviceAccount:${var.cloud_storage_sa}"
}

resource "google_cloudfunctions2_function" "zipper" {
  project     = var.project_id
  name        = "zipper-app"
  location    = var.gcp_region
  description = "Zipper Application Function"

  build_config {
    runtime     = "python310"
    entry_point = "process_uploaded_file"
    source {
      storage_source {
        bucket = resource.google_storage_bucket.deploy.name
        object = "zipper.zip"
      }
    }
  }

  service_config {
    max_instance_count             = 1
    min_instance_count             = 1
    available_memory               = "256Mi"
    timeout_seconds                = 120
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email          = var.cloud_function_sa
    environment_variables = {
      TARGET_BUCKET = resource.google_storage_bucket.dest.name
    }
  }

  event_trigger {
    trigger_region        = var.gcp_region
    event_type            = "google.cloud.storage.object.v1.finalized"
    service_account_email = var.cloud_function_sa
    event_filters {
      attribute = "bucket"
      value     = resource.google_storage_bucket.source.name
    }
  }
}
