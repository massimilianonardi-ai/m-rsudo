# m-rsudo

Independent source package for the actual `rsudo`, `rsudo-admin`, `rssh`
commands and all eight original `rsudo` shell modules, with operational
manuals and the existing remote testlab scenario. No credentials or host
secrets are stored in this repository.

The immutable `v0.1.0`, `v0.1.1` and `v0.1.2` GitHub releases were
built from their respective source revisions. `pkg-catalog/pkg-schema-v2`
records their exact separate versions and command/library projections.
The current `build.sh` emits a distinct `v0.1.2` archive; previous release
assets must never be replaced.

`rsudo` uses the separately installed `m-core` shell libraries. For
`rsudo-admin`, `m-term` also supplies the actual terminal menu. Select
the exact three installed concretes in the invoking shell:

```sh
context pkg=m-core@v0.1.1 pkg=m-term@v0.1.1 pkg=m-rsudo@v0.1.2
```

The GitHub-hosted Ubuntu/macOS public `pkg install` test (`m-core` run
`42037725004`) verified shell-library projection and the real non-network
`rsudo` module-dispatch error path.
It does **not** prove remote SSH/sudo behavior, `rsudo-admin` remote-menu
source injection, or `rssh` interactive shell integration. The immutable
`v0.1.0` artifacts still have legacy global-library path assumptions.
The newer immutable source releases corrected the package-local paths.
Hosted public installation/consumer checks passed on Ubuntu and macOS for
`v0.1.1` (run `42097660573`), while privileged remote operation remains unverified. A real privileged end-to-end test must use an
explicitly authorized SSH/sudo test target.

Current main source realigns `rsudo-admin` Browse host with the selected
package-owned `m-core` and `m-term` shell libraries and the shared
`menu-command.lib.sh` source, using the existing `rsudo exec inject`
transport. This source requires coordinated newer m-core/m-term packages and
is published in the separate immutable `m-rsudo/v0.1.1` release; the
`v0.1.0` artifact remains unchanged. The v2 catalog lists both versions. Actual SSH/sudo and
interactive remote browsing still need an authorized real target.

The `m-rsudo/v0.1.2` release additionally guards its own selected package
library lookup before POSIX dot-source, preventing a missing file from
terminating a noninteractive shell with an unexpected setup status. Hosted
public installation, error-branch, source-injection and local PTY checks are
tracked separately by the `r1-installed-v012` workflow. Such tests cannot
establish a privileged SSH/sudo or remote interactive browser PASS.
