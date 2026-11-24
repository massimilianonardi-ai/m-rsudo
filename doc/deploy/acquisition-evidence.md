# Acquisition evidence, coverage and checks — proposed

See [contract](initial-acquisition.md) and [operations](acquisition-operations.md). This is a collection artifact format, not the desired deployment JSON schema. No runtime test or collection executed.

## Private run layout

```text
<approved-private-root>/<run-id>/
  manifest.json       # nonsecret scope and provenance
  steps.jsonl         # sanitized status records
  raw/                # restricted necessary native responses only
  observations/       # classified/normalized observations, not desired state
  coverage.json       # domain/instance/category coverage and unresolved refs
  report.md           # sanitized operator review, still private by default
```

Create a fresh directory under operator-approved private root; restrictive umask (077), directory 0700 and files 0600 or stricter; verify owner, ACL, symlink/path isolation and adequate space. Raw may contain secrets despite requested fields: never display/log/upload, never store unnecessary raw if safe filtering is possible; reject unknown sensitive structures from sanitized output. Capture stdout and stderr separately in restricted storage, no tee to normal job log, no shell tracing. Do not persist passwords/API keys/session tokens/private keys or unrelated user directory; if unavoidable in native responses, quarantine only when explicitly authorized with encryption/retention, otherwise discard safely and mark unavailable. Do not assume deletion is secure erasure; minimize collection first. No public Git commit of raw, normalized configuration, private paths/hostnames or identity data. Only sanitized, nonidentifying status and source revision may enter public task state.

## Record contract

Each step records run/step/operation IDs, logical target+instance reference, category and global/application scope, start/end UTC, collector revision, manifest digest, actual nonsecret command/interface reference, exit/status, page/record counts, safe error category and restricted artifact reference. Keep artifact digest for permitted nonsecret data only or integrity-protected private evidence; do not expose secret hashes. Timestamp and source IDs accompany observations. Do not conflate native IDs with logical IDs; namespace by target/instance/realm/source. Preserve meaningful nonsecret unknown fields in restricted evidence for analysis; no silent field drops or assumptions.

Coverage per expected category: complete | partial | blocked | failed | unsupported | not_applicable (with verified reason) | inconsistent. Only complete, verified enumeration supports absence within exact scope. HTTP failure, invalid JSON, pagination error, permission denial, timeout, missing tool, or unknown scope cannot become empty success. Record all expected areas even when skipped. Detect duplicate IDs, unresolved references, pagination loops, incomplete includes, revision changes. Independent reads are not a distributed atomic snapshot: record time windows, re-read relevant summaries/revisions when possible, flag inconsistency if evidence changes. No auto-repair.

Run outcome: complete only if required categories for both levels complete or justified not_applicable, references resolved or explicitly nonblocking, secret policy satisfied; otherwise partial/blocked/failed. No normalization of unobserved fields into defaults. No deployment enabled merely by acquisition completion. Review candidate desired project separately.

## Planned checks (not executed)

| ID | Fixture / check | Expected |
| --- | --- | --- |
| ACQ-T01 | invalid target, path or manifest, missing approval | no remote invocation |
| ACQ-T02 | captured command list with synthetic adapters | only allowlisted reads; no mutation, no secret argv |
| ACQ-T03 | APISIX response with headers, non-2xx or malformed body | parse valid response; errors not absence |
| ACQ-T04 | pagination duplicates, truncated list, unstable totals | partial/inconsistent with explicit evidence |
| ACQ-T05 | Keycloak session unavailable or needs unapproved cache write | blocked; no implicit login |
| ACQ-T06 | synthetic secrets in body/error/config, unknown field | no plaintext in ordinary log/report; quarantine/discard policy |
| ACQ-T07 | symlink/path escape, existing destination, insufficient disk | refuse unsafe transfer; preserve prior runs |
| ACQ-T08 | interruption/timeout, one unavailable instance | preserve valid partial evidence, stop affected dependencies; no success claim |
| ACQ-T09 | multi-instance global+app sample with broken reference | trace references and report gaps, block affected future actions |
| ACQ-T10 | authorized real acquisition, independently verify sample source facts | complete only on actual scoped coverage and evidence; no live change, no operational acceptance inferred |

Local fixtures/CI are not real acquisition. Before real collection, operator approves exact target/identity/data/session/storage and limits; after collection, review coverage and unknowns before JSON design. Keep subsequent schema/architecture gates unchanged.
