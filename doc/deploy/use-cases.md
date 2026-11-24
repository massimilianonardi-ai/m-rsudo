# Use cases (L3)

**The original menu/CLI wiring cases UC-01–04 remain implemented only for the initial slice.** Their former description of `rsudo-deploy help` as unconditional delegation describes legacy code, not the revised approved general contract.

| ID | Actor/action | Expected observable outcome | State |
| --- | --- | --- | --- |
| UC-01 | Run `rsudo-deploy` with no arguments. | Own menu opens, Escape returns. | Initial implementation |
| UC-02 | From `rsudo-admin`, choose Deploy with loaded credential groups. | Source-only menu inherits groups; returning does not modify admin state. | Initial implementation / synthetic CI |
| UC-03 | Invoke `rsudo-deploy <local operation>`. | Library CLI parses args and performs local-only work with no rsudo remote call. | **Approved; not implemented** |
| UC-04 | Invoke `rsudo-deploy <remote orchestration request>`. | Library CLI validates local plan, then calls existing rsudo remote operation(s) as needed. | **Approved; not implemented** |
| UC-05 | Create or progressively edit a desired deployment project. | Revised project saved without server changes. | Approved; pending |
| UC-06 | Review an entire project or selected subset. | Validation, dependency/target analysis, observed state, explicit differences and blockers; no mutations. | Approved; pending |
| UC-07 | Prepare a deployment that may take hours. | All checkable prereqs and failure risks assessed; versioned execution scope and recovery decision points. | Approved; pending details |
| UC-08 | Apply approved part or all of plan. | Operations executed in dependency order with precise logs. | Approved; pending |
| UC-09 | Verify deployed web app via intended URL. | Served assets plus required authn/authz behavior are independently observed; residual discrepancies reported. | Approved; pending details |
| UC-10 | Unexpected third-party change on a server. | Drift flagged and classified; no auto-reconciliation/redeployment. | Approved; pending |
| UC-11 | A module lacks a required capability. | Separate task/contract for owning component, no unapproved modifications. | Approved; process |
| UC-12 | Unattended run meets a blocker or partial failure. | Deterministic stop/reconciliation/report per approved policy; no implicit destructive rerun. | Principle approved; policy pending |

**First representative application:** HTML/JS/CSS app made available through existing nginx/APISIX/Keycloak estate; exact topology, route ownership and policy model still require evidence/approval.
