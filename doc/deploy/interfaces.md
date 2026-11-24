# Interfaces and failure contracts (L5)

| ID | Entry | Owner | Contract |
| --- | --- | --- | --- |
| IF-01 | `rsudo deploy help` | `rsudo-mod-deploy.lib.sh` | Print first-slice CLI help, zero on success; rsudo's established credential validation applies first. |
| IF-02 | `rsudo-deploy` | `bin/sys/rsudo-deploy` | Load m environment and source-only menu library, call `rsudo_deploy_menu`. |
| IF-03 | `rsudo-deploy <args>` | `bin/sys/rsudo-deploy` | `exec rsudo deploy "$@"`; preserve original argument vector and exit code. |
| IF-04 | `rsudo_deploy_menu` | `rsudo-deploy.lib.sh` | Source-only function. Runs in subshell; Escape returns success, invalid menu/setup returns nonzero. |
| IF-05 | `rsudo-admin` Deploy entry | `bin/sys/rsudo-admin` | Resolve selected m-rsudo package view, source library in subshell, invoke menu; report outcome in admin footer. |
| IF-06 | Existing rsudo group variables | `rsudo.lib.sh` / m-core | Existing credential contract; consumed, never redefined. |

Only `rsudo_deploy_menu` is exposed as a menu entrypoint. Helpers prefixed `_rsudo_deploy_` are implementation details and not stable external APIs.

**Current limitation:** in the first slice, interactive menu supports loading a credentials file, listing/selecting loaded groups, and CLI usage. Infrastructure-resource commands will be added only after their models and safety contracts are defined.

For execution and errors, see [use cases](use-cases.md) and [tests](tests.md).
