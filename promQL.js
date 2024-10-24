//Elements Processed
//This query calculates the rate of elements being processed by the Dataflow job splunk-push
rate(dataflow_elements_processed_total{job_name="splunk-push"}[1m])

//Total Processing Lag
//This query calculates the average total processing lag for the job.
avg_over_time(dataflow_processing_lag_seconds{job_name="splunk-push"}[5m])


//CPU Utilization
//This query calculates the average CPU usage by the workers running the splunk-push Dataflow job.
100 - (avg by (instance) (rate(node_cpu_seconds_total{job_name="splunk-push", mode="idle"}[1m])) * 100)

//Memory Usage
//This query calculates the memory usage by the workers.
100 * (1 - (avg by (instance) (node_memory_MemAvailable_bytes{job_name="splunk-push"})) / (avg by (instance) (node_memory_MemTotal_bytes{job_name="splunk-push"})))

//Stage Execution Time
//This query calculates the average execution time of the pipeline stages over a 5-minute window.
avg_over_time(dataflow_stage_execution_time_seconds{job_name="splunk-push"}[5m])

//System Latency
//This query measures the system latency over time.
avg_over_time(dataflow_system_latency_seconds{job_name="splunk-push"}[5m])

// Autoscaling Decisions
//This query tracks the rate of autoscaling decisions for the job.
rate(dataflow_autoscaling_decisions_total{job_name="splunk-push"}[1m])

