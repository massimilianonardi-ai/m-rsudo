# Acceptance (L3/L11) — observed vs future

Existing first-slice **source interface** evidence: [Ubuntu/macOS synthetic CI](https://github.com/massimilianonardi-ai/m-rsudo/actions/runs/45345542189), commit `3f80ce65`. It established menu sourcing, synthetic credential-group visibility, wrapper argument forwarding and packaging. The forwarding behavior is now **superseded as a future CLI contract**; CI PASS is historical, not proof of the revised CLI.

| ID | Target acceptance | Current evidence |
| --- | --- | --- |
| ACCEPT-01 | `rsudo-deploy` menu invoked alone or from rsudo-admin and returns cleanly | Initial synthetic integration PASS |
| ACCEPT-02 | `rsudo-deploy <args>` calls library CLI; local operation does **not** call rsudo; remote operation delegates via established rsudo | **Not implemented/tested** |
| ACCEPT-03 | Multi-step project edit/revision makes no remote changes | Pending |
| ACCEPT-04 | Selected/full plan compilation yields reproducible diff, dependency ordering and actionable blockers | Pending |
| ACCEPT-05 | Preflight rejects unexamined blockers; long-running plan has durable progress/restart/reconciliation evidence | Pending design |
| ACCEPT-06 | Execute only approved change scope and honor explicit destructive authorization | Pending |
| ACCEPT-07 | For web app URL: verify accessible assets for entitled identity and enforced denial for unauthenticated/unauthorized access at the real public boundary | Pending; topology/auth model not specified |
| ACCEPT-08 | Final report correlates each attempted operation with independently observed postconditions and remaining drift; never states success based only on exit code | Pending |
| ACCEPT-09 | Detect changed server state after plan preparation and avoid silently applying a stale plan | Pending details |
| ACCEPT-10 | No modifications to protected rsudo components and no production execution without authorization | Current source baseline intact; monitor continuously |

**Acceptance limitation:** logs alone cannot guarantee configuration state or security. Certification of outcome requires applicable postcondition readback and external access tests with evidence. No new remote deploy behavior has been verified.

## First-scenario refinement

[SCN-01 acceptance cases](scenario-01-acceptance.md) expand the web application checks and negative cases. They are proposed, not executed; review [open scenario decisions](scenario-01-decisions.md) before fixing acceptance or implementing dependent contracts.
