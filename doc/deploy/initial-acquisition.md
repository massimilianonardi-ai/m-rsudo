# Initial acquisition — concrete design contract (proposal)

Authority: REQ-06/09/10/11/18–24, SCN-D01–D08 approved. This revision designs collection only; no authorization for live access, new executable code, changes to protected components or publication of infrastructure data. Source contracts inspected at m-rsudo@27705b4ac4dedb1bc4f1ee2d178d9efa7c3ec57a. See [operations](acquisition-operations.md), [evidence and checks](acquisition-evidence.md), [resource model](resource-model.md).

## ACQ-01 — Responsibility and flow

Local deploy-owned controller (eventually shared by menu/CLI) validates a private collection manifest, selects existing credential groups, invokes fixed read operations using rsudo, captures output/status, validates/redacts and emits evidence. Remote source is only narrowly scoped observation via existing exec or native module; no new transport, service, remote persistent agent or dependency task assumed. Initial collection may be operator-run in existing rsudo-admin/job context, using the same contracts. This is the recommended approach, not approved final CLI syntax or implementation. No arbitrary commands from JSON, no credential loading from untrusted files. Reuse established rsudo authentication; no retesting/reimplementation of transport.

```text
private manifest -> local preflight -> authorized target preflight
 -> bounded domain reads -> restricted evidence -> coverage review
 -> normalized candidate project -> operator review -> desired baseline
```

Do not normalize into desired state automatically; no apply/redeploy is part of acquisition.

## ACQ-02 — Private manifest (collection input, not desired schema)

| Field | Required meaning |
| --- | --- |
| run_id | Unique local run identity; never overwrite an older run |
| targets | Explicit logical target IDs, existing credential-group references, permitted domains, expected instance/role; no credentials |
| endpoints | Operator-approved Admin API/realm/hosting/source endpoint references; exact known paths or explicitly bounded discovery roots |
| authority | Approved targets/domains, allowed observation operations, permitted identity scope, session handling, duration/volume ceilings |
| storage | Operator-approved private local path, access and retention, sanitized report destination |
| source | Exact collector revision, manifest digest, scope and operator authorization reference |

One server may host multiple instances and one domain may have multiple targets. Unknown cloaker placement is resolved by evidence within authorized candidate targets, not network scanning. Group selection from existing in-memory state: rsudo --load ":<group>" ...; validate identifiers and select in an isolated subshell; never enumerate secret values. No assumptions about actual names, privilege or paths.

## ACQ-03 — Phases and gates

| Phase | Outputs / gates |
| --- | --- |
| A local preflight | Validate manifest, tool versions/capability, fixed operation inventory, storage permissions and available space, credential group references without printing values, per-step limits. No remote calls. Present targets, data categories, estimated work and exclusions. |
| B remote preflight | Only after explicit approval: inspect target identity/instance/version, supported read API and selected privilege; report inaccessible/ambiguous targets and unknown paths. No auto-enrollment or broad scan. |
| C collection | Only operations in [allowlist](acquisition-operations.md) matched to installed capability; independent steps, bounded reads and page enumeration; restricted stdout/stderr. Stop affected branch on ambiguous target, auth error, unsafe response or unsupported operation. |
| D coverage review | Verify completeness, references, consistency, secret classification; repeat bounded reads if concurrent change suspected, otherwise mark inconsistent. No empty-as-absent fallback. |
| E normalization | Separate proposal after observations: native references, ownership classes, unsupported fields, desired candidate vs observed facts. Approval before establishing baseline. |

No new remote files, restarts/reloads, PUT/PATCH/DELETE, configuration updates, identity changes, offline exports, raw database dumps or AD administration. Authentication may cause audit entries, session creation and local token cache writes: use already authorized session where possible; any new session/cache handling requires explicit scope and validation. Strict no-write collection cannot silently include those effects. No host-key enrollment, installed dependencies, or temporary remote scripts/files without separate approval. Existing rsudo runtime housekeeping remains outside product configuration semantics.

## ACQ-04 — Boundaries and unresolved operator inputs

Before executing even preflight B, confirm (1) authorized execution context and explicit target/group map, (2) allowed realms/identity attributes and existing admin access/session policy, (3) private storage path/retention and data export permission, (4) time/volume budget and allowed public probes. Assistant prepares implementation/runner after required architecture/code authorization; no remote access asserted. Missing read capability blocks that section; report and propose separate dependency task only with evidence. Product schema and full CLI are still unresolved, not inferred from this manifest.

## ACQ-05 — Result

A run produces evidence and a coverage report, not a restore archive or proof of production correctness. Both global and app-level coverage are required; partial results useful but affected writes remain blocked. See [evidence](acquisition-evidence.md) for acceptance and failure tests.
