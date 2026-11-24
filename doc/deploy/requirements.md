# Requirements (L2) — approved contract and open design

This file supersedes overbroad wording of REQ-03 from the first interface slice. Entries marked **approved** reflect operator directions, not necessarily implemented behavior.

| ID | Requirement | Authority | Delivery state |
| --- | --- | --- | --- |
| REQ-01 | `rsudo deploy <args>` retains normal rsudo semantics and performs remote work using credentials activated through the existing model. | Approved | Module `help` only |
| REQ-02 | `rsudo-deploy` with no args presents a self-contained interactive menu. | Approved | Initial menu implemented |
| REQ-03 | `rsudo-deploy <args>` calls a **complete CLI function in `rsudo-deploy.lib.sh`**; that function composes local operations and, when necessary, remote `rsudo deploy`/existing modules. No unconditional forwarding. | Approved, 2026-11-24; supersedes original REQ-03 scope | **Not implemented** |
| REQ-04 | `rsudo-admin` is otherwise unchanged; its Deploy menu item sources the menu library in a subshell with inherited unexported credential groups. | Approved | Initial integration implemented |
| REQ-05 | Menu and CLI use shared domain operations; no second application engine. | Approved | Core pending |
| REQ-06 | Reuse rsudo's encrypted credential, unattended and remote access contracts; never put secrets in deployment JSON or invent parallel transport. | Approved | Protected |
| REQ-07 | Sourceable menu/library defines functions without load-time side effects or implicit execution. | Approved | Initial sourceable menu implemented |
| REQ-08 | Deployment **project** is a staged and revisable desired configuration. A deployment applies all or a chosen part to servers. | Approved | Model pending |
| REQ-09 | Gather actual state and compare to desired project for deployment, operational and security discrepancy detection. Do not modify the project or redeploy automatically. | Approved | Pending |
| REQ-10 | `rsudo`, `fs`, `db-pg`, `exec` are immutable in this task; `rsudo-admin` may change only for Deploy item; edits to `apisix`, `keycloak`, `keysix` require separate explicit consent and task. | Approved | Enforced by scope |
| REQ-11 | Initial deployment targets **existing APISIX, Keycloak, nginx** and static HTML/JS/CSS apps exposed by URL with authentication and authorization. | Approved | Pending |
| REQ-12 | Before execution, compute differences, dependencies, possible blockers and risk; preparation should minimize failures in hours-long deployments. | Approved | Design pending |
| REQ-13 | Execute an explicitly authorized plan/part, produce precise logs and verify actual postconditions; distinguish completed commands from verified deployment. | Approved | Pending |
| REQ-14 | Destructive changes and unattended operations need explicit, noninteractive authorization; exact policy pending design. | Principle approved | Policy pending |
| REQ-15 | Encountered defects or missing features in protected rsudo modules or other tools become **independent tasks**; deployment design may define needed contracts but cannot silently edit those components. | Approved | Enforced by scope |

## Scenario refinements approved (2026-11-24)

| ID | Requirement | Delivery state |
| --- | --- | --- |
| REQ-16 | Single intended user entry via minimal HTML cloaker/iframe to APISIX; HTTPS URLs, HTTP redirect; public distinct APISIX/Keycloak, no new reverse proxy prerequisite. | Pending |
| REQ-17 | Application origins accessible via APISIX only; separate nginx allows app connections from APISIX only; colocated nginx binds 127.0.0.1. DNS pre-existing; TLS certificates within deployment scope, potentially later increment. | Pending |
| REQ-18 | Preserve dedicated realm/AD integration and existing APISIX client authorization model; roles, paths and permissions exclusively deployment-managed; association changes supported by deployment and ordinarily performed in Webadmin. | Pending |
| REQ-19 | Ready-to-copy static content from local Git or private intranet bare Git; bare Git authoritative; no build process. | Pending |
| REQ-20 | Deployment authoritative for infrastructure resources including APISIX/Keycloak, except explicitly permitted ordinary association management; initial export required, no automatic drift remediation. | Pending |

| REQ-21 | Deployment manages the cloaker; APISIX entrance is an app menu; ordinary apps are exposed only through APISIX paths; protected direct APISIX access is valid. | Pending |
| REQ-22 | Preserve current public HTTPS and HTTP APISIX-to-nginx baseline; alternative topology/internal TLS assessed separately. | Pending |
| REQ-23 | Support AD and local Keycloak users/groups; group administration is not exclusive to deployment; preserve D02 association and structural ownership boundaries. | Pending |
| REQ-24 | Initial export acquires infrastructure/global and application configuration levels; write support is incremental. | Pending |

See [scenario decisions](scenario-01-decisions.md) for D01–D08 and [resource model](resource-model.md) for proposed engineering contracts.

## Proposals pending detailed architecture

- Directory-based structured JSON project with stable identities, references, and revision/fingerprint per executable plan; no final JSON schema yet.
- Immutable/reconstructible preparation artifact tied to observed state, target selection and approved scope.
- Fail on unexamined blockers; reconcile ambiguous partial operations explicitly, with no automatic drift remediation.
- Logs + readback/postcondition checks yield evidence, not a mathematically absolute guarantee from the log alone.

See [initial scenario](initial-scenario.md), [lifecycle](deployment-lifecycle.md), [component protection](component-protection.md). 
