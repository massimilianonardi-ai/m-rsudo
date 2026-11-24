# Integration tests (L7)

Do **not** re-test rsudo's established SSH/sudo/credential algorithms as part of the new project's design. Test only newly introduced boundaries.

| ID | Test | Fixture | Assertion | Current status |
| --- | --- | --- | --- | --- |
| TEST-01 | Shell parse of new/changed files | POSIX `sh -n` | All parse | Pending repository checkout execution |
| TEST-02 | Source-only library | `sh` sourcing menu library | Loading defines functions; does not launch menu | Pending execution |
| TEST-03 | Credential-group visibility in subshell | Synthetic, unexported group values | Menu library can enumerate group name; no password printed | Pending execution |
| TEST-04 | CLI forwarding | Stub executable `rsudo` | `rsudo-deploy a b` invokes `rsudo deploy a b` preserving argument boundaries | Pending execution |
| TEST-05 | Admin integration | Stubbed `menu` and selected package path | Deploy selects sourced library, exits back to admin | Pending execution |
| TEST-06 | Packaging | `build.sh` new output dir | Binary and source files included | Pending execution |
| TEST-07 | Old entrypoint smoke | Existing m-rsudo consumer baseline | Existing module call/legacy menu items unaffected | Pending execution |

A privileged live remote test is not required to accept the **interface wiring**, but is needed before claiming any new remote resource administration is operational. Existing rsudo credential behavior is assumed, not questioned.

A synthetic local copy of the new shell files was parsed with dash and bash. A stub CLI forwarding check and group-name visibility check passed; these are **not** package-install or rsudo transport tests. The repository test below runs directly against the checked-out source and is still pending.

Run in a checked-out tree: `sh tests/deploy-entrypoints.sh`.
