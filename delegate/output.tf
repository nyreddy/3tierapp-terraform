output "cloud_run_url" {
  value = google_cloud_run_service.harness_delegate.status[0].url
}
