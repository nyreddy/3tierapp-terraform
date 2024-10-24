provider "google" {
  project = "<your_project_id>"
  region  = "us-central1"
}

# Create a custom dashboard for a specific Dataflow job with the name 'splunk-push'
resource "google_monitoring_dashboard" "dataflow_dashboard" {
  dashboard_json = jsonencode({
    displayName: "Dataflow Job 'splunk-push' Monitoring Dashboard",
    gridLayout: {
      columns: 3,
      widgets: [
        {
          title: "Elements Processed",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/elements_processed_count" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
          title: "Total Processing Lag",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/total_lag" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
          title: "CPU Utilization",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/worker/physical_cpu_utilization" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
              label: "Percentage",
            },
          },
        },
        {
          title: "Memory Usage",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/worker/memory_utilization" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
              label: "Percentage",
            },
          },
        },
        {
          title: "Stage Execution Time",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/step/execution_time" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
          title: "System Latency",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/system_lag" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
          title: "Autoscaling Decisions (VMs)",
          xyChart: {
            dataSets: [
              {
                timeSeriesQuery: {
                  timeSeriesFilter: {
                    filter: 'metric.type="dataflow.googleapis.com/job/autoscaling/num_vms" AND resource.type="dataflow_job" AND resource.label.job_name="splunk-push"',
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
              label: "VMs",
            },
          },
        },
      ],
    },
  })
}
