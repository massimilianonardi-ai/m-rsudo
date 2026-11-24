# Decisions — provenance and alternatives (L4)

| ID | Choice | State / origin | Rejected alternative |
| --- | --- | --- | --- |
| ADR-01 | All new sources remain in existing `m-rsudo` repository/package. | Operator-approved | Separate `m-rsudo-deploy` repository/package |
| ADR-02 | `rsudo deploy` is the authoritative CLI module; menu delegates to same functions as they are added. | Operator-approved | Duplicated menu-side administration |
| ADR-03 | Sourceable library `rsudo-deploy.lib.sh` contains menu; `rsudo-deploy` executable remains a thin independent entrypoint. | Operator-approved | Mixed executable/sourceable script or menu only inside rsudo-admin |
| ADR-04 | `rsudo-admin` adds one menu entry calling the library in a subshell. | Operator-approved | Full deploy menu inside rsudo-admin or external child process |
| ADR-05 | No changes to rsudo credential model or dispatcher as a prerequisite. | Explicit operator directive | New local pre-auth dispatch or independent SSH/credential system |
| ADR-06 | First code increment implements interface wiring and basic credential-group menu, not mutating deployment actions. | Assistant scoped implementation | Premature unapproved infrastructure schema/mutations |

Consequences: no second repo, no password export/IPC, no duplicated authorization logic. Future model/resource architecture remains open; see [execution plan](execution-plan.md).
