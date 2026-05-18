# PerkPilot — Seed

## Problem
Our bank wants to launch a customer perks program.
- Ops team creates and manages perks.
- Customers find perks via natural-language chat in the mobile app.

## Two features
1. Perk catalog (CRUD) — ops users only.
2. Conversational discovery — customers ask in plain English.

## Constraints from the org

### Compliance & data
- **RBI data residency:** all data and compute in India (`centralindia` or `southindia` only).
- **Audit log on every state change** (create, update, delete, status change) with actor + timestamp + before/after.
- **PII handling:** customer identifiers in chat logs must be masked at rest.
- **Retention:** perk records retained 7 years; chat transcripts 90 days (subject to confirmation).

### Platform & deployment (constraints git-ape must honor)
- **Allowed Azure regions:** `centralindia`, `southindia` only.
- **No anonymous customer-facing endpoints.** Every public route must require authentication.
- **Managed identity required** for the app — no connection strings or keys in config.
- **HTTPS only.** No HTTP ingress, no self-signed certs.
- **Least-privilege RBAC.** No `Owner` or `Contributor` role for the app's identity; scope to specific resources.
- **Mandatory resource tags:** `env`, `owner`, `cost-center`, `data-classification`.
- **Cost ceiling for non-prod:** ≤ ₹15,000 / month estimated at deploy time. Anything higher requires explicit override.
- **Approved Azure services only:** Container Apps, Azure AI Foundry, Azure SQL / SQLite for prototype, Azure Container Registry, Log Analytics, Key Vault. Anything else triggers a review.
- **Observability:** Log Analytics workspace attached; Application Insights wired in.

### AI-specific
- **Content Safety filter** must be applied to all customer chat input and output.
- **No model fallback to public LLM endpoints** — only models hosted via the bank's Azure AI Foundry project.
- **Grounded answers only** — chat responses must cite which perk(s) they came from.

