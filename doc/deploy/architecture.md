# Architecture — approved boundaries, proposed composition (L4)

**Current source baseline:** `m-rsudo@05d1b08791a3f85c47b619a2f1169edbe5953332`. **Operator-approved:** one repo/package, independent CLI/menu, immutable rsudo credential dispatcher, local vs remote split and staged desired project.

```text
rsudo-admin --Deploy--> (source rsudo-deploy.lib.sh; rsudo_deploy_menu)
                                                   |
rsudo-deploy (no args) -----------------------------+
rsudo-deploy (args) ------> rsudo_deploy_cli "$@"    | [APPROVED / NOT YET CODED]
                             |                     |
                          Orchestrator (shared functions)
                             |
          +------------------+------------------+
          |                  |                  |
      LOCAL PROJECT     OBSERVE & PLAN      REMOTE EFFECTS
       JSON/files      diff/deps/preflight    via rsudo
          |                  |                  |
          +------------- deployment evidence --+
                                               |
                                     existing server instances
                                     APISIX / Keycloak / nginx
```

Native `rsudo deploy <args>` is **only one remote-operation adapter**. Other existing rsudo modules may be invoked where appropriate. No requirement that local operation passes through rsudo. Existing `rsudo` validates remote credentials before dispatch: preserved by design.

The desired **project** may be edited/revised in stages without accessing a server. A chosen revision/selection is compared with observed state before forming a proposed execution plan. An approved prepared plan is applied, then independently verified. Drift does **not** automatically mutate the desired project or trigger apply.

The operator confirmed intended HTTPS cloaker/iframe entry -> public APISIX -> restricted nginx origin, with publicly reachable Keycloak on a distinct server and existing AD-backed realm and authorization client. See [scenario decisions](scenario-01-decisions.md). Exact plugin/enforcement and upstream TLS boundary are not yet verified; do not replace the existing topology or assume a particular mechanism. Deployment is authoritative for managed infrastructure, with the explicit ordinary Keycloak association exception.

For per-component ownership see [components](components.md); for preparation/long execution see [lifecycle](deployment-lifecycle.md). All source diagrams are design intent unless tagged implemented.
