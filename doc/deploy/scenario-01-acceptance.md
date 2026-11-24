# SCN-01 — representative acceptance cases (proposed L3)

**Status:** proposed checks, not tests executed. Parent requirements REQ-08–15 and UC-05–12. Refine expected result with approved [scenario decisions](scenario-01-decisions.md). Test local units independently before composed behavior. Use an authorized test environment for actual deployment, not production by default.

| ID | Scenario | Required evidence / expected result |
| --- | --- | --- |
| SCN-A01 | Create/edit/revise app project without connection | Desired revision changes locally; no remote operation called |
| SCN-A02 | Validate invalid references, unavailable source, conflicting URL | Precise diagnostics; no mutations; invalid preparation blocked |
| SCN-A03 | Observe absent, present, conflicting and unreachable resources | Absence distinct from unknown; observations retain source/time; unrelated objects unchanged |
| SCN-A04 | Prepare selected application with shared dependencies | Explicit changes and scope, dependency order, checkable preconditions, conflicts, unresolved/blocked operations; no remote writes |
| SCN-A05 | Targeted content update | Change only selected content and genuinely required dependencies; unnecessary Keycloak/APISIX updates excluded |
| SCN-A06 | Apply reviewed plan in authorized test environment | Attempts and verified postconditions correlated; no unapproved resource changes |
| SCN-A07 | Unauthenticated visitor | Protected URL/content challenged or denied before protected assets delivered; no exposed bypass path in declared threat boundary |
| SCN-A08 | Authenticated but not authorized visitor | Access denied; no protected bytes delivered |
| SCN-A09 | Authorized visitor | Expected URL, HTML and required static assets served with expected content; correct policy and valid response |
| SCN-A10 | Failed stage, stale observation or unobservable postcondition | No false success; block dependent effects, record known/unknown/partial outcomes and operator decision; no automatic redeploy |
| SCN-A11 | Existing/shared resource or third-party change | Conflict or drift reported; no implicit takeover, deletion or overwriting outside approved ownership |
| SCN-A12 | Long-running/unattended plan | Authorized scope and durable precise logs; no secrets disclosed; verify each material action/result; no prompts unless operation explicitly interactive |

The exact login flow, denial status, identities, URL scope, treatment of public assets and bypass test boundary depend on scenario decision SCN-D02. Do not equate a successful administrative response with correct public access. An unreachable verification target produces an inconclusive outcome, not a verified deployment.
