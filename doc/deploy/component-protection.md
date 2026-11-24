# Component ownership and protected interfaces

**Operator directives, binding for this task, 2026-11-24.**

| Component | Ownership | May this task modify it? |
| --- | --- | --- |
| `rsudo`, dispatcher, credential model, native runtime | Existing rsudo product | **No, under any circumstances of this task** |
| `rsudo fs`, `rsudo db-pg`, `rsudo exec` | Existing modules | **No** |
| `rsudo-admin` | Existing admin console | **Only the addition of one Deploy menu entry** (already introduced) |
| `rsudo apisix`, `rsudo keycloak`, `rsudo keysix` | Existing modules | Only with **prior explicit consent**, as separately scoped tasks |
| New `rsudo deploy` module | Deployment remote adapter | Yes, within approved product contracts |
| `rsudo-deploy.lib.sh` and new local deploy libraries | Local CLI, menu, orchestration | Yes, within approved product contracts |
| Other tools outside deployment | Independent owner | No changes here; open separate task when needed |

## Separate-task handoff

When a missing capability is found, this task documents: desired observable behavior, current verified limitation, existing owner/interface, required input/output/error contract, compatibility risks and acceptance check. Then suspend only the dependent deployment milestone. The owning tool's change is implemented/tested in its own task after required approval. Avoid duplicate or opportunistic fixes inside deploy.

The existing CI for rsudo credential internals is not re-opened merely because new orchestration consumes the interface. Test **new integration boundaries**, not existing resolved implementation.
