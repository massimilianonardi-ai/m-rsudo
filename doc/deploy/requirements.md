# Requirements (L2)

| ID | Requirement | Authority | Initial slice |
| --- | --- | --- | --- |
| REQ-01 | CLI entry `rsudo deploy <operation>` uses native rsudo module dispatch. | Approved | `help` entry |
| REQ-02 | `rsudo-deploy` without arguments opens its own interactive menu. | Approved | Implemented |
| REQ-03 | `rsudo-deploy <args>` delegates to `rsudo deploy <args>`, preserving argument boundaries. | Approved | Implemented |
| REQ-04 | `rsudo-admin` adds one Deploy menu entry; sourced library is invoked via a subshell. | Approved | Implemented |
| REQ-05 | Deploy menu and CLI do not duplicate administrative operations. | Approved | Core work pending |
| REQ-06 | Reuse rsudo's existing credential loading, no plaintext secrets in deployment JSON, no independent SSH/sudo. | Approved | Preserved |
| REQ-07 | Sourceable menu library has no load-time execution or credential changes. | Approved approach | Implemented |
| REQ-08 | Desired infrastructure model uses a structured directory of JSON resources. | Direction proposed | Data design pending |
| REQ-09 | Future operations support observation, plan, targeted apply and verify, with explicit destructive controls. | Direction proposed | Not implemented |
| REQ-10 | Do not change rsudo's established credential mechanism or regress existing commands. | Explicit operator directive | Preserved (no rsudo.lib.sh edits) |

Unresolved specifications: JSON schema/resource IDs, desired/observed state representation, policy for remote side effects, CLI operation catalog, idempotence, safety of product-specific adapters. None is silently treated as approved by this initial integration slice.

Traceability: [use cases](use-cases.md) → [interfaces](interfaces.md) → [tests](tests.md).
