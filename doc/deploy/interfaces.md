# Interfaces — current vs approved future contract (L5)

| ID | Interface | Owner | Contract / status |
| --- | --- | --- | --- |
| IF-01 | `rsudo [options] deploy <remote operation>` | `rsudo-mod-deploy.lib.sh` | Remote-only rsudo module. Existing rsudo dispatcher, credentials and options fully preserved. `help` only currently implemented. |
| IF-02 | `rsudo-deploy` | `bin/sys/rsudo-deploy` | With no args loads sourceable menu library and calls `rsudo_deploy_menu`. Initial implementation. |
| IF-03 | `rsudo-deploy <args>` | `bin/sys/rsudo-deploy` → `rsudo-deploy.lib.sh` | Calls proposed `rsudo_deploy_cli "$@"` function. **APPROVED, not implemented**. Current `exec rsudo deploy "$@"` is a historical interim implementation to replace. |
| IF-04 | `rsudo_deploy_menu` | `rsudo-deploy.lib.sh` | Source-only, enters menu in subshell, performs orchestration via local functions and remote rsudo calls when needed. Initial menu present. |
| IF-05 | Deploy menu entry | `rsudo-admin` | Only new menu item; source own selected package library in subshell, call `rsudo_deploy_menu`; does not own deploy business logic. Implemented. |
| IF-06 | Remote credential groups and native commands | Existing `rsudo` / `m-core` | Consume existing unexported shell state and native rsudo options; no changes or new auth flow. |
| IF-07 | Desired project store | New deploy-local library (TBD) | Load/validate/revise selected JSON project resources without remote effects; schema not yet agreed. |
| IF-08 | Observe/diff/prepare/apply/verify | New deploy orchestration libraries (TBD) | Stable explicit scopes, immutable recorded plan/evidence, remote adapters only for remote effects; signatures TBD. |

**No premature public verb grammar** is approved. Local vs remote command routing is a design requirement; exact subcommands and selector syntax must be specified before CLI changes. Source-only functions should not run on load; avoid duplicating policy logic between menu and CLI.
