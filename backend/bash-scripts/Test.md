Datadog AKS Cost Optimization – YAML Configuration Documentation

Purpose

This document explains how and why each section of the Datadog YAML configuration is used to reduce monitoring cost in an AKS (Azure Kubernetes Service) environment.

The goal is to:
	•	Reduce log ingestion volume
	•	Control APM trace usage
	•	Prevent metric tag explosion
	•	Keep only high‑value observability data

This document is written in a knowledge‑transfer (KT) style for Ops / SRE / DevOps engineers.

⸻

Scope

This documentation covers cost optimization for:
	•	Datadog Agent (Helm)
	•	Kubernetes logs
	•	APM (traces)
	•	Metrics & tags
	•	AKS‑specific noise

Out of scope: RUM, Synthetics, and custom metrics (can be documented separately).

⸻

High‑Level Cost Drivers in Datadog

Area	Cost Driver	Typical Issue
Logs	Ingestion volume	Health checks, debug logs, kube events
APM	Trace volume	Default 100% sampling
Metrics	High cardinality tags	pod_name, container_id
Processes	Process agent	Not always required

This YAML addresses all of the above.

⸻

1. Global Datadog Settings

datadog:
  site: datadoghq.com
  apiKeyExistingSecret: datadog-secret

Explanation
	•	Uses Kubernetes Secret instead of hardcoding the API key
	•	Required for secure and compliant deployments
	•	No direct cost impact, but mandatory for production

⸻

2. Global Tags (Prevent Tag Explosion)

  tags:
    - env:production
    - cluster:aks-prod
    - region:centralus

Why this matters
	•	Tags are attached to every metric, log, and trace
	•	Keep tags low‑cardinality (environment, cluster, region)

❌ Avoid
	•	pod_name
	•	container_id
	•	request_id

Cost impact

✅ Prevents metric cardinality explosion

⸻

3. Log Collection Strategy (Major Cost Saver)

  logs:
    enabled: true
    containerCollectAll: false
    containerCollectUsingFiles: true

Explanation
	•	containerCollectAll: false
	•	Logs are collected only from annotated pods
	•	Prevents ingesting logs from every container automatically

Required pod annotation

annotations:
  datadoghq.com/logs: 'true'

Cost impact

🔥 30–50% reduction in log ingestion

⸻

4. Log Processing Rules (Drop Noise Before Billing)

logProcessingRules:
  - type: exclude_at_match
    name: drop_k8s_health
    pattern: "(healthz|readyz|livez|/metrics|kube-probe)"

What this drops
	•	Kubernetes health checks
	•	Prometheus scrapes
	•	Liveness/readiness probes

These logs have no troubleshooting value.

⸻

Debug Log Exclusion

  - type: exclude_at_match
    name: drop_debug_logs
    pattern: "\\bDEBUG\\b"

Why
	•	Debug logs are noisy and high volume
	•	Should not be enabled in production by default

⸻

Kubernetes Event Noise

  - type: exclude_at_match
    name: drop_kube_events_normal
    pattern: "type:Normal"

Explanation
	•	Kubernetes events of type Normal are informational
	•	Errors and warnings are still collected

⸻

AKS / Azure CNI Noise

  - type: exclude_at_match
    name: drop_azure_cni_spam
    pattern: "(azure-cni|cni).*"

Explanation
	•	Azure CNI generates frequent low‑value logs
	•	Dropping these significantly reduces log volume

⸻

5. APM (Tracing) Cost Control

apm:
  enabled: true
  env:
    - name: DD_TRACE_SAMPLE_RATE
      value: "0.10"

Explanation
	•	Default sampling = 100% (very expensive)
	•	10% sampling still provides accurate latency and error trends

Cost impact

✅ 10–20% reduction in APM cost

⸻

Ignore Health Endpoints in Traces

- name: DD_APM_IGNORE_RESOURCES
  value: "GET /healthz,GET /metrics"

Why
	•	Health endpoints distort latency metrics
	•	Zero troubleshooting value

⸻

6. Disable Process Agent (If Not Needed)

processAgent:
  enabled: false

Explanation
	•	Process Agent collects process‑level metrics
	•	Useful for deep troubleshooting, not always required

Cost impact

🔥 Can save up to 25% if unused

⸻

7. Control Orchestrator Explorer Tags

orchestratorExplorer:
  enabled: true
  extraLabelsAsTags:
    node:
      - agentpool

Explanation
	•	Limits which node labels become tags
	•	Prevents high‑cardinality labels from being indexed

⸻

8. Prevent High‑Cardinality Container Tags

containerEnvAsTags:
  DD_TAG_EXCLUDE:
    - container_id
    - pod_name
    - image_id

Why
	•	These values change frequently
	•	Each new value creates new metric series

Cost impact

✅ Reduces metric and index growth

⸻

9. Agent‑Level Optimizations

agents:
  containers:
    agent:
      env:
        - name: DD_LOGS_CONFIG_USE_V2_API
          value: "true"

Explanation
	•	Uses newer, more efficient log pipeline
	•	Reduces agent CPU and ingestion overhead

⸻

Summary: Cost Savings by Area

Area	Estimated Savings
Log exclusion & filtering	🔥 30–50%
Pod‑only log collection	🔥 20–40%
APM sampling	10–20%
Disable process agent	Up to 25%
Tag optimization	5–15%


⸻

Operational Best Practices
	•	Review Datadog → Usage weekly
	•	Alert on log ingestion spikes
	•	Enforce pod log annotations via policy
	•	Use lower sampling in non‑prod environments

⸻

Ownership & Change Control
	•	YAML changes must be reviewed by SRE / Ops
	•	Any new integration must justify cost impact
	•	Changes should be applied via GitOps or Terraform

⸻

End of document
