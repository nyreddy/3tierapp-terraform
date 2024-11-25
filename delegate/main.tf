resource "google_cloud_run_service" "harness_delegate" {
  name     = var.harness_delegate_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "harness/delegate:latest" # Replace with the desired delegate image version
        env  [
          {
            name  = "DELEGATE_NAME"
            value = var.harness_delegate_name
          },
           {
            name  = "NEXT_GEN"
            value = "true"
          },
           {
            name  = "DELEGATE_TYPE"
            value = "DOCKER"
          },
          {
            name  = "ACCOUNT_ID"
            value = var.harness_account_id
          },
          {
            name  = "DELEGATE_TOKEN"
            value = var.harness_delegate_token
          },
          {
            name  = "LOG_STREAMING_SERVICE_URL"
            value = "https://app.harness.io/log-service/" 
          },
           {
            name  = "MANAGER_HOST_AND_PORT"
            value = ""
          },
        ]

        resources {
          limits = {
            memory = "2048Mi"
            cpu    = "1"
          }
        }
      }
      service_account_name = google_service_account.harness_delegate_sa.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "allow_all" {
  service = google_cloud_run_service.harness_delegate.name
  location = google_cloud_run_service.harness_delegate.location
  role    = "roles/run.invoker"
  member  = "allUsers"
}
