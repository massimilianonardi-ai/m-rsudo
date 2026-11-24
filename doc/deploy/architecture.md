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

A possible initial request flow is static files on nginx through APISIX routes protected using Keycloak-backed identity/authorization. **Exact placement of access enforcement and topology is unresolved**; do not assume a particular APISIX plugin or admin API without inspecting the estate.

For per-component ownership see [components](components.md); for preparation/long execution see [lifecycle](deployment-lifecycle.md). All source diagrams are design intent unless tagged implemented.
