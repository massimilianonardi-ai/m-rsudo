# m-rsudo

Independent source package for the actual `rsudo`, `rsudo-admin`, `rssh`
commands and all eight original `rsudo` shell modules, with operational
manuals and the existing remote testlab scenario. No credentials or host
secrets are stored in this repository.

The immutable `v0.1.0` GitHub release is produced by
`sh build.sh release` and described in `pkg-catalog/pkg-schema-v2` as
a real `m-rsudo` package with installed shell-library and command views.

`rsudo` uses the separately installed `m-core` shell libraries. For
`rsudo-admin`, `m-term` also supplies the actual terminal menu. Select
the exact three installed concretes in the invoking shell:

```sh
context pkg=m-core@v0.1.0 pkg=m-term@v0.1.0 pkg=m-rsudo@v0.1.0
```

The GitHub-hosted Ubuntu/macOS public `pkg install` test (`m-core` run
`42037725004`) verified shell-library projection and the real non-network
`rsudo` module-dispatch error path.
It does **not** prove remote SSH/sudo behavior, `rsudo-admin` remote-menu
source injection, or `rssh` interactive shell integration. The immutable
`v0.1.0` artifacts still have legacy global-library path assumptions.
The current source branch has corrected those assumptions, but requires new
coordinated package releases and authentic installed-package validation before
it can be called operational. A real privileged end-to-end test must use an
explicitly authorized SSH/sudo test target.

Current main source realigns `rsudo-admin` Browse host with the selected
package-owned `m-core` and `m-term` shell libraries and the shared
`menu-command.lib.sh` source, using the existing `rsudo exec inject`
transport. This source requires coordinated newer m-core/m-term packages and
is not part of the immutable `m-rsudo/v0.1.0` release. Actual SSH/sudo and
interactive remote browsing still need an authorized real target.
