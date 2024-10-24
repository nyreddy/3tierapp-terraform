provider "google" {
  project = "<your_project_id>"
  region  = "us-central1"
}

# Create a custom dashboard for Dataflow Job metrics
resource "google_monitoring_dashboard" "dataflow_dashboard" {
  dashboard_json = jsonencode({
    displayName: "Dataflow Job Monitoring Dashboard",
    gridLayout: {
      columns: 2,
      widgets: [
        {
          title: "Dataflow Job Processing Time",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/total_lag" AND resource.type="dataflow_job"',
                    aggregation: {
                      alignmentPeriod: "60s",
                      perSeriesAligner: "ALIGN_MEAN",
                    },
                  },
                },
              },
            ],
            timeshiftDuration: "0s",
            yAxis: {
              label: "Seconds",
            },
          },
        },
        {
          title: "Dataflow Job Elements Processed",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/elements_processed_count" AND resource.type="dataflow_job"',
                    aggregation: {
                      alignmentPeriod: "60s",
                      perSeriesAligner: "ALIGN_RATE",
                    },
                  },
                },
              },
            ],
            timeshiftDuration: "0s",
            yAxis: {
              label: "Elements",
            },
          },
        },
        {
          title: "Dataflow Job System Latency",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/system_lag" AND resource.type="dataflow_job"',
                    aggregation: {
                      alignmentPeriod: "60s",
                      perSeriesAligner: "ALIGN_MEAN",
                    },
                  },
                },
              },
            ],
            timeshiftDuration: "0s",
            yAxis: {
              label: "Seconds",
            },
          },
        },
      ],
    },
  })
}
