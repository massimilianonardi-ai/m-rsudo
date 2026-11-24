# Objectives (L1)

**Approved scope, 2026-11-24.** Build `rsudo-deploy` in existing `m-rsudo` as a cohesive deployment orchestration product with a complete CLI and independent interactive menu. Provide a staged, reviewable **desired project** and apply its whole or selected scope to existing servers using existing rsudo capabilities.

## First accepted target outcome

Administer **already-existing APISIX, Keycloak and nginx instances** so an operator can publish a set of web applications consisting of **HTML, JavaScript and CSS** under specified URLs, protected by Keycloak-backed authentication and authorization at the intended access boundary. More resource kinds will be introduced incrementally.

## Quality goals

- Prepare long-running deployments thoroughly: discover actual state, compare to plan, identify blockers/dependencies before execution.
- Execute selected authorized changes, log reliably, verify real outcomes and expose residual discrepancies.
- Support unattended execution within rsudo's established remote credentials model, without plaintext secrets in plans.
- Keep small components with explicit, testable ownership; refer missing tool/module functionality to **separate tasks** rather than changing them here.

## Exclusions

No changes to rsudo, rsudo fs/db-pg/exec or the credential architecture. Change rsudo-admin **only** by adding the Deploy menu entry. Changes to rsudo apisix/keycloak/keysix require prior explicit operator consent and are handled by separate tasks. No autonomous remediation/redeployment when drift is detected. No production execution authorized by these specifications.
