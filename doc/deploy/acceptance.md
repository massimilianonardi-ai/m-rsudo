# Acceptance and current evidence (L3/L11)

The first delivery slice is **interface wiring**, not a finished infrastructure manager.

| Check | Expected | Observed |
| --- | --- | --- |
| ACCEPT-01 | Native rsudo dispatcher resolves `deploy help` with ordinary rsudo credentials. | Source integration added; no actual SSH or installation run |
| ACCEPT-02 | Admin selection invokes same source-only menu in a subshell and returns. | Source integration added; interactive PTY run pending |
| ACCEPT-03 | Standalone executable launches menu without operands and forwards with operands. | Source implementation added; installed-package run pending |
| ACCEPT-04 | No changes to `rsudo.lib.sh`, credential encryption or existing module implementations. | Verified by changed-file scope |
| ACCEPT-05 | New module/lib/executable are present in build projection. | Build recipe updated; package install run pending |
| ACCEPT-06 | No remote operations are launched by first-slice menu items. | Confirmed from source; operational tests pending |

No claim of rsudo credential-model verification is made or needed here; it is treated as an established dependency. Follow [tests](tests.md) for integration-specific verification.
