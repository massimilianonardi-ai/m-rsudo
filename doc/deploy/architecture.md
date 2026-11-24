# Architecture (L4)

**Status:** approved deployment entrypoint topology; first interface-only slice.

```text
rsudo-admin menu -> ( source rsudo-deploy.lib.sh; rsudo_deploy_menu )
                                    ^
                                    |
rsudo-deploy (no args) --------------+
rsudo-deploy (args) -> rsudo deploy <args> -> rsudo-mod-deploy.lib.sh
                                              |
                                         future deploy core
                                              |
                                      existing rsudo modules
```

`rsudo-admin` owns only its menu entry, selected-package library lookup and session lifecycle. `rsudo-deploy.lib.sh` owns menu presentation, selection and local session credential view, not remote transport. `rsudo-deploy` is a thin executable. `rsudo-mod-deploy.lib.sh` owns the native CLI entrypoint; future resource adapters use existing `rsudo` modules. The JSON deployment directory is separate from credentials.

**Credential scope:** rsudo-admin has already loaded groups as unexported shell variables; a POSIX subshell inherits them. A new standalone executable cannot inherit an unrelated shell's unexported variables, so its own menu may load the same encrypted file through existing `encoded_file_eval`. Remote operations always go through standard `rsudo`; no auth bypass.

**Current native dispatch limitation:** `rsudo()` validates a remote connection before entering any module; the approved choice is to **preserve that behavior**. The standalone menu handles local configuration display without calling native rsudo until remote administration is requested. No restructuring of rsudo's authentication is needed.

No cross-package module resolution or new extension framework; all files ship inside existing `m-rsudo`.
