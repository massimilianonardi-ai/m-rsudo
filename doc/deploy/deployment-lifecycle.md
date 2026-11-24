# Long-running deployment lifecycle — proposed execution contract

**Approved requirements:** prepare before execution; detect differences, blockers and possible failures; deploy all/part of project; log precisely; verify independently; discrepancies require manual case-by-case handling. **Detailed stage implementation is proposed**, not yet approved.

| Stage | Proposed output / gate |
| --- | --- |
| 1. Draft/revise | Versioned desired project; no remote writes |
| 2. Validate | Local schema/references/targets/selection checks and all objectively knowable configuration problems |
| 3. Observe | Actual state and its source/time/collection confidence; no assumption when unreachable |
| 4. Compare | Per-resource diff: no-change, create/change/remove candidate, drift, unknown, conflict |
| 5. Prepare | Ordered actions, dependencies, hazards, estimates, permissions/capabilities and explicit blockers; preflight endpoints/content/auth policy |
| 6. Review/authorize | Identify exact project revision, selected scope, prepared plan and permitted destructive effects |
| 7. Execute | Apply ordered authorized steps; durable attempt/progress logging; stop/continue policy defined per action |
| 8. Verify | Independent readback, service reachability, URL behavior, authentication/authorization and content checks as relevant |
| 9. Close | Verified/partial/failed/inconclusive outcome, remaining differences and explicit operator next decisions |

**Important:** a preparation check cannot rule out all future failures during hours of execution. The system should detect changed preconditions just before affected actions; stale plans must not silently apply. Re-running deploy after detected drift is **manual**, not automatic.

### Open engineering contracts to design

1. Which state changes invalidate a prepared plan; what constitutes fresh observation?
2. Failure policy per action: stop, retry, skip, or operator intervention; safe recovery of partially completed steps without implicit reapplication.
3. What is a destructive operation and how is noninteractive authorization bound to plan/scope?
4. How to coordinate concurrent deployments or external actor modifications without hidden conflict.
5. Whether some resources support transactional staging/activation/rollback; never assume this of APISIX/Keycloak/nginx.

See [logging](logging-evidence.md) and [acceptance](acceptance.md).
