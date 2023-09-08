locals {
  sa_roles_helper = flatten([for sa, value in var.service_accounts :
    [for role in value.roles :
      {
        "sa"   = sa
        "role" = role
      }
    ]
  ])
}

resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  account_id   = each.key
  display_name = each.value.display_name
}

resource "google_project_iam_member" "project_iam" {
  for_each = { for idx, record in local.sa_roles_helper : idx => record }
  project  = var.project_id
  role     = each.value.role
  member   = "serviceAccount:${google_service_account.service_account["${each.value.sa}"].email}"
}

output "cloud_function_sa_email" {
  value       = google_service_account.service_account["cloud-functions-app-sa"].email
  description = "Cloud Function SA email, pass this value to the app terraform"
}
