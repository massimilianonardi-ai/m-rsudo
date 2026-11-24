# Deployment project and state — model principles

**Approved:**
- A **project** is desired configuration; editable and reviewable over multiple steps.
- A deployment is applying a selected part or all of one project revision to servers.
- Observed state is separately gathered and compared; drift can reveal deployment errors, third-party edits and security issues.
- Neither drift detection nor successful review changes desired configuration or automatically redeploys.

## Proposed conceptual records (not JSON schema)

| Concept | Meaning | Primary owner |
| --- | --- | --- |
| Project | Desired configuration and independent revision history | Local project store |
| Resource | An app, URL exposure, gateway route, identity/policy object, hosting target or other explicitly supported kind | Local model |
| Selection | Full project or explicit subset, including dependency closure rules | Planner |
| Observation | Timestamped state from a defined server/API, including unknown/unavailable | Observer |
| Difference | Classified desired vs observed discrepancy, with supporting observations | Comparator |
| Prepared plan | Reviewed ordered actions for a specific project revision/selection and observed state | Planner |
| Execution record | Attempts/results for those actions plus correlation IDs and evidence | Execution subsystem |

Resources may have references/dependencies; the exact JSON directory structure, IDs, schema versions, revision mechanism, inheritance/overrides and partial-selection semantics are **unresolved**.

### Invariants to design/test

- Project revisions do not silently change because of remote drift.
- Unavailable observation is **unknown**, not interpreted as absent.
- Deploy selection does not silently omit required dependencies.
- Preparation and execution bind to a specific desired revision and documented observed baseline.
- Secrets are outside JSON and resolved only through rsudo's established model.

See [lifecycle](deployment-lifecycle.md) for proposed state transitions.

## Resource model refinement

See [resource-model](resource-model.md) for conceptual areas, authority classes and dependency semantics; see [initial-acquisition](initial-acquisition.md) for the read-only import boundary. This does not fix the JSON schema.
