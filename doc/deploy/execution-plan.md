# Incremental development plan (L8)

**Top-down deployment task.** Changes needed in existing rsudo modules/other products become separate tasks and are never silently implemented here.

| Step | Outcome and check | State |
| --- | --- | --- |
| STEP-01 | Entrypoints/menu integration source, packaging and synthetic CI on Ubuntu/macOS ([evidence](https://github.com/massimilianonardi-ai/m-rsudo/actions/runs/45345542189)) | **Completed historically**, prior CLI-forwarding contract |
| STEP-02 | Revise approved CLI contract: `rsudo-deploy` → `rsudo_deploy_cli`; retained menu/admin boundaries; local calls do not require rsudo | **Approved, implementation pending** |
| STEP-03 | First scenario architecture: inventory APISIX/Keycloak/nginx capabilities, current module interfaces, trust/access paths and app authz semantics | Design pending |
| STEP-04 | JSON project model, revisions, identities, selections, references, validation, observed/diff states | Design pending |
| STEP-05 | Plan/preflight/approval contract for hours-long runs; step dependencies and destructive risk policy | Design pending |
| STEP-06 | Durable logging, postcondition evidence and manual discrepancy handling contract | Design pending |
| STEP-07 | First complete vertical path from project revision → validation → remote read-only observation → plan | Code pending gates |
| STEP-08 | Apply prepared limited app exposure via APISIX/Keycloak/nginx through existing rsudo capabilities; verify both positive and negative access behavior | Code pending approvals and capability evidence |
| STEP-09 | Recovery, unattended execution, regression tests and operational release/acceptance | Future; external host access requires authorization |

**Immediate next work:** produce one comprehensive reviewable choice synthesis for the first scenario, with explicit operator decisions needed on actual access path/authorization model and resource ownership. Avoid implementing guess-based JSON schema or modifying protected modules before contracts and approvals.

**No deployment execution or release publication is authorized by this plan.** The released `m-rsudo/v0.1.3` remains immutable.
