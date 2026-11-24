# SCN-01 — existing tool contracts and potential dependencies

**Source baseline:** `m-rsudo@c69da1ee14cf9c44cb8f9d40ac1b595608e78359`. Static source/manual inspection, not live server discovery, version compatibility verification or tests of established rsudo behavior.

| Existing owner | Inspected contract | Candidate use | Conditions / limitations |
| --- | --- | --- | --- |
| `rsudo fs` | `get remote_path local_path`; `put local_path remote_path [owner_group] [permissions]`; `rm`; explicit recursive `delete` | Read/write files and content | Replacement staging is not a single transaction; check space, ownership, path isolation; no implicit destructive fallback |
| `rsudo exec` | `inject` source composition, named commands and optional one-shot/stream source | Remote read-only observation; selected nginx admin operations | stdin is shell source; retain native credential/connection semantics |
| `rsudo apisix` | `rest METHOD RESOURCE [BODY]` (HTTP methods, mandatory APISIX_KEY, configurable APISIX_ADMIN_URL, default remote localhost traditional Admin API); `key /ABSOLUTE/PATH` | List/read/update relevant gateway resources | Actual Admin API mode/version/plugin availability unknown; output includes HTTP headers. Dispatcher debug logs module args, so secret-bearing JSON must not be passed unexamined via argv. Key result is sensitive. Do not infer working CRUD composition from wrapper presence. |
| `rsudo keycloak` | `kcadm <args>` invokes executable at remote RSUDO_KEYCLOAK_PATH; optional KC_CLI_PASSWORD; stdin closed | Realm/client/group/role operations through official CLI if supported | kcadm owns authentication; its file operands refer to remote paths. No assumed stdin payload. Verify actual command/API capability and secret handling, without redesigning existing transport. |
| `rsudo keysix` | `help` only | None required by default | No operational API implemented at inspected revision. |
| nginx | No dedicated rsudo module | Inspect/configure existing static hosting using fs/exec | Runtime location, config ownership, validation/reload method and topology unknown. |

Sources: [APISIX](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/lib/sys/sh/rsudo/rsudo-mod-apisix.lib.sh), [Keycloak](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/lib/sys/sh/rsudo/rsudo-mod-keycloak.lib.sh), [Keysix](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/lib/sys/sh/rsudo/rsudo-mod-keysix.lib.sh), [fs manual](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/res/sys/manual/rsudo-mod-fs.lib.sh), [exec manual](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/res/sys/manual/rsudo-mod-exec.lib.sh), [dispatcher](https://github.com/massimilianonardi-ai/m-rsudo/blob/c69da1ee14cf9c44cb8f9d40ac1b595608e78359/lib/sys/sh/rsudo/rsudo.lib.sh#L388).

## Required capability evidence (before dependent implementation)

- Gateway: installed version/mode, relevant route/upstream/plugin schema, ability to observe/update selected configuration; identity and authorization integration actually available.
- Identity: installed version, administrative access and intended resource model; available kcadm operations; session/secret handling in supported interface.
- Hosting: installed nginx type/location, managed document root/config, network paths from gateway and potential bypass; validation/activation procedures.
- Content: source/artifact identity, required permissions, reliable remote observation and fingerprint.
- Access testing: available test identity mechanism and representative allowed/denied cases; no real credentials in public repo or logs.

No live targets were contacted. These are discovery inputs, not observed facts. Missing capabilities become separate tasks with specific contracts and explicit consent when required, not speculative changes to existing modules. No such task is opened solely because a capability has not yet been checked.
