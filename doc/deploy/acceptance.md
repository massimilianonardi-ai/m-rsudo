# Acceptance and current evidence (L3/L11)

The first delivery slice is **interface wiring**, not a finished infrastructure manager.

| Check | Expected | Observed |
| --- | --- | --- |
| ACCEPT-01 | Native rsudo dispatcher resolves `deploy help` with ordinary rsudo credentials. | Source integration added; no actual SSH or installation run |
| ACCEPT-02 | Admin selection invokes same source-only menu in a subshell and returns. | PASS in synthetic UI test on Ubuntu/macOS; real interactive PTY not tested |
| ACCEPT-03 | Standalone executable launches menu without operands and forwards with operands. | PASS in synthetic invocation on Ubuntu/macOS; installed m-os package run pending |
| ACCEPT-04 | No changes to `rsudo.lib.sh`, credential encryption or existing module implementations. | Verified by changed-file scope |
| ACCEPT-05 | New module/lib/executable are present in build projection. | PASS in source build on Ubuntu/macOS; package install run pending |
| ACCEPT-06 | No remote operations are launched by first-slice menu items. | Confirmed from source; operational tests pending |

No claim of rsudo credential-model verification is made or needed here; it is treated as an established dependency. Follow [tests](tests.md) for integration-specific verification.

**Evidence:** [deployment entrypoint CI, Ubuntu and macOS](https://github.com/massimilianonardi-ai/m-rsudo/actions/runs/45345542189), commit `3f80ce65`. The integration checks do not exercise or question rsudo's established credential transport. They do not establish remote deployment readiness.
