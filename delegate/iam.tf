resource "google_service_account" "harness_delegate_sa" {
  account_id   = "harness-delegate"
  display_name = "Harness Delegate Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "delegate_roles" {
  for_each = toset([
    "roles/storage.admin",
    "roles/run.invoker",
    "roles/logging.logWriter",
  ])

  project = var.project_id
  member  = "serviceAccount:${google_service_account.harness_delegate_sa.email}"
  role    = each.key
}
