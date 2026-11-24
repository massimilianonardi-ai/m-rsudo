# Component responsibility map (L5, proposed internal structure)

**Binding boundaries:** `rsudo-admin` has a single menu hook; `rsudo` credentials/dispatcher unchanged; `rsudo deploy` is remote-only; local CLI and workflow belong to deployment-owned libraries.

| Component | Owns | Does not own |
| --- | --- | --- |
| `bin/sys/rsudo-deploy` | Initializing selected package libraries; invoking `rsudo_deploy_menu` without args or `rsudo_deploy_cli "$@"` with args | Business logic, credentials, SSH/sudo |
| `rsudo-deploy.lib.sh` | Sourceable menu and public CLI function, validation/dispatch into cohesive local helper functions | Remote authentication |
| Local project/model libraries (TBD) | JSON project edits, references, revision identity, validation | Remote state |
| Observer/comparator (TBD) | Remote readback via existing rsudo interfaces; factual differences and unknowns | Silently changing desired project |
| Planner/preflight (TBD) | Scope/dependencies, blocker detection, ordered actions, execution plan | Unapproved mutation |
| Executor/verifier/logging (TBD) | Controlled apply using rsudo, evidence correlation, postconditions and outcome | Implicit drift remediation |
| `rsudo-mod-deploy.lib.sh` | Remote commands for deployment that are owned by the new module | Local JSON-only operations |
| Existing rsudo modules | Their already-defined remote operations | New deployment planning; do not edit protected modules |
| `rsudo-admin` | One menu item and sourceable-library entry | Deploy menu implementation |

**Technical decomposition is not fixed:** one library may serve multiple small responsibilities until complexity justifies splitting. CLI verbs, internal functions and argument schemas are subject to next focused design. Reuse existing module interfaces only after verifying their actual supported operations.
