provider "google" {
  project = "your-main-project-id" # Replace with your base project
}

provider "google" {
  alias   = "secondary"
  project = "your-secondary-project-id" # Replace if managing org-level resources
}

variable "projects" {
  default = ["dv-ulx", "qa-ulx"] # Replace with your actual project IDs
}

resource "google_project_iam_member" "custom_role_binding" {
  for_each   = toset(var.projects)
  project    = each.value
  role       = "roles/custom.CustomSecurityPolicyAdmin" # Replace with the exact custom role
  member     = "serviceAccount:srv-ztne-infra-b-c-np-secrets-b20c@prj-c-np-secrets.iam.gserviceaccount.com"
}

resource "google_project_organization_policy" "disable_global_armor" {
  for_each   = toset(var.projects)
  project    = each.value
  constraint = "constraints/compute.disableGlobalCloudArmorPolicy"

  list_policy {
    allow {
      all = true
    }
  }
}
