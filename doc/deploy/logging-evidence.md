# Logging, verification and audit evidence

**Approved goal:** logs must support investigation of errors, technical root-cause analysis and evidence-based certification of deployment results; many deployments may last hours.

## Proposed minimum event record

| Field | Purpose |
| --- | --- |
| `run_id`, `plan_id`, `project_revision`, `selection` | Correlate execution with authorized desired scope |
| `step_id`, `resource_id`, `operation`, `target` | Identify the exact action/owner |
| Start/end timestamp and duration | Reconstruct timeline and slow steps |
| Planned preconditions and observed preflight status | Explain why action was allowed or blocked |
| Attempt count, status/exit information, sanitized diagnostic | Differentiate retries, failures and skipped actions |
| Before/after state references and verification IDs | Link actions to independent observations |
| Final outcome and unresolved discrepancies | Support review and manual follow-up |

Structured machine-readable events should coexist with concise operator-readable summaries. Log detail must enable analysis **without dumping passwords, tokens, access keys or sensitive content**. Protect log integrity/permissions and correlate to exact project revision, action plan and approved scope.

### Evidence hierarchy

1. Command exited successfully: proves only that a command completed under its own semantics.
2. Product API/readback agrees with required configuration: proves the observed state at the sampling point.
3. External behavior tests (public route, content, authn/authz) confirm intended service behavior at the sampled boundary.
4. Comprehensive outcome report combines relevant evidence and identifies anything not verified.

**Do not use "guaranteed" as an unsupported absolute claim.** An audit trail can establish verifiable facts, but dynamic systems may change afterward. Define explicit measurable acceptance and report inconclusive parts honestly.

### Open questions

Evidence retention/location/permissions, interruption and crash durability, secret redaction rules, artifact hashes, monotonic action IDs, export/certification format and log verification/signing are pending design.
