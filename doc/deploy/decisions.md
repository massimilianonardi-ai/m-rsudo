# Decisions and supersessions (L4)

**Authority:** operator clarifications through 2026-11-24. Historical decisions are retained but not made global beyond context.

| ID | Decision and rationale | State |
| --- | --- | --- |
| ADR-01 | Keep deployment code in existing `m-rsudo` repo/package. | **Approved** |
| ADR-02 | Earlier `rsudo deploy` as universal CLI backend was acceptable for first slice, **but superseded** by ADR-07. | **Superseded for whole CLI** |
| ADR-03 | Separate source-only `rsudo-deploy.lib.sh` from thin executable; menu has no duplicated engine. | **Approved** |
| ADR-04 | `rsudo-admin` adds only Deploy item, invoking source-only menu in subshell to inherit nonexported groups. | **Approved** |
| ADR-05 | Do not alter rsudo credentials, dispatcher or established remote model; local-only operations do not pass through rsudo. | **Approved binding restriction** |
| ADR-06 | First interface slice only, with no actual resource mutation. | **Implemented historical scope** |
| ADR-07 | `rsudo-deploy <args>` is a wrapper around a **complete CLI function** in `rsudo-deploy.lib.sh`; local funcs and rsudo remote ops are selected by need. | **Approved; implementation pending** |
| ADR-08 | Desired project is edited/revised independently, deployment applies selected/full scope, observed drift prompts human case-by-case review, never automatic redeploy. | **Approved; implementation pending** |
| ADR-09 | First real scenario: existing APISIX, Keycloak, nginx; HTML/JS/CSS apps exposed via URLs with authentication and authorization. Other tech/features later. | **Approved** |
| ADR-10 | Missing/change-needed rsudo or other product capability is a **separate task**; changes to apisix/keycloak/keysix require fresh explicit consent; rsudo/fs/db-pg/exec immutable; admin only Deploy menu item. | **Approved binding restriction** |
| ADR-11 | Deployment potentially hours: thorough diff/preflight/risks/authorization, detailed logs and independent evidence of result. | **Approved principle** |

**Proposed, not yet accepted:** exact resource JSON schema and identifier model; user-facing CLI verb hierarchy; route/authz policy representation; preflight snapshot freshness and plan approval token; retry/resume semantics; any per-resource transactional guarantees. Do not silently substitute these for approved decisions.

Review [initial scenario](initial-scenario.md), [plan model](plan-model.md), [lifecycle](deployment-lifecycle.md), [logging](logging-evidence.md) before implementing them.
