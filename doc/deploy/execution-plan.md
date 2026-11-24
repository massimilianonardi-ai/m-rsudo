# Incremental development plan (L8)

**Top-down deployment task.** Changes needed in existing rsudo modules/other products become separate tasks and are never silently implemented here.

| Step | Outcome and check | State |
| --- | --- | --- |
| STEP-01 | Entrypoints/menu integration source, packaging and synthetic CI on Ubuntu/macOS ([evidence](https://github.com/massimilianonardi-ai/m-rsudo/actions/runs/45345542189)) | **Completed historically**, prior CLI-forwarding contract |
| STEP-02 | Revise approved CLI contract: `rsudo-deploy` → `rsudo_deploy_cli`; retained menu/admin boundaries; local calls do not require rsudo | **Approved, implementation pending** |
| STEP-03 | First scenario architecture: inventory APISIX/Keycloak/nginx capabilities, current module interfaces, trust/access paths and app authz semantics | D01–D08 answered; concrete read-only acquisition contract proposed; authorization and real discovery pending |
| STEP-04 | JSON project model, revisions, identities, selections, references, validation, observed/diff states | Design pending |
| STEP-05 | Plan/preflight/approval contract for hours-long runs; step dependencies and destructive risk policy | Design pending |
| STEP-06 | Durable logging, postcondition evidence and manual discrepancy handling contract | Design pending |
| STEP-07 | First complete vertical path from project revision → validation → remote read-only observation → plan | Code pending gates |
| STEP-08 | Apply prepared limited app exposure via APISIX/Keycloak/nginx through existing rsudo capabilities; verify both positive and negative access behavior | Code pending approvals and capability evidence |
| STEP-09 | Recovery, unattended execution, regression tests and operational release/acceptance | Future; external host access requires authorization |

**Immediate next work:** review the proposed [acquisition contract](initial-acquisition.md), [operation catalog](acquisition-operations.md) and [evidence/checks](acquisition-evidence.md); confirm actual targets/access/session/storage scope and required implementation authorization, then perform separately authorized collection and review results before JSON and full architecture synthesis. Avoid guess-based schemas, premature apply and protected module changes.

**No deployment execution or release publication is authorized by this plan.** The released `m-rsudo/v0.1.3` remains immutable.
