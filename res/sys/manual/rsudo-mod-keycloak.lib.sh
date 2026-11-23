NAME
    rsudo-mod-keycloak.lib.sh - native Keycloak administration CLI over rsudo

SYNOPSIS
    rsudo [rsudo-options...] keycloak kcadm [kcadm-args...]

DESCRIPTION
    Forwards the kcadm arguments unchanged to the official kcadm.sh on the
    selected remote rsudo host. The Keycloak server can be a different host.
    rsudo handles SSH/sudo; kcadm.sh handles Keycloak credentials, sessions,
    token management, REST, and command parsing. No proprietary Keycloak
    administration API or authentication protocol is implemented.

    Future simplified "rsudo keycloak ..." operations, if any, are separate
    from the universal "rsudo keycloak kcadm ..." namespace.

REQUIRED LOCAL ENVIRONMENT
    RSUDO_KEYCLOAK_PATH
        Absolute path to the executable kcadm.sh ON THE REMOTE HOST selected
        by rsudo (under the effective sudo user). Required for every call.
        No executable discovery, PATH fallback, or default path is used.
        The remote file must exist and be executable.

OPTIONAL LOCAL ENVIRONMENT
    KC_CLI_PASSWORD
        Password for Keycloak's native CLI authentication, transported to the
        remote kcadm.sh process as the environment variable KC_CLI_PASSWORD.
        The value can contain spaces, quotes, shell metacharacters and newlines.
        If unset locally, it is not set for the remote kcadm process.
        Empty and unset values are distinct.

    Standard rsudo connection/identity settings and options are unchanged.
    RSUDO_PASSWORD is managed by rsudo and is not used as the Keycloak password.

EXAMPLES
    export RSUDO_KEYCLOAK_PATH=/opt/keycloak/bin/kcadm.sh
    export KC_CLI_PASSWORD='administrator secret'

    rsudo keycloak kcadm config credentials \
        --server https://keycloak.example.org --realm master --user admin

    rsudo keycloak kcadm get realms
    rsudo keycloak kcadm get users -r example
    rsudo keycloak kcadm create users -r example \
        -s username=sample -s enabled=true
    rsudo keycloak kcadm help

    To avoid persistent CLI session state, use Keycloak's original
    --no-config mode and its required native options. Consult Keycloak's
    own kcadm help for version-specific command syntax.

EXECUTION CONTRACT
    The module generates a POSIX shell script on stdin and invokes the
    existing rsudo noninteractive remote execution path. It never places
    the Keycloak password in SSH/sudo command-line arguments. Quoted shell
    assignments preserve the exact value of KC_CLI_PASSWORD and each CLI
    argument, including trailing newline characters.

    The remote script checks the explicitly configured executable, then
    executes it directly with all original kcadm arguments.

    stdout, stderr and exit status are those of kcadm.sh once launched.
    Missing or invalid RSUDO_KEYCLOAK_PATH fails locally (status 64);
    an absent or nonexecutable remote file fails remotely (status 127).
    Errors from the rsudo transport are returned according to rsudo itself.

LIMITATIONS
    This wrapper uses noninteractive rsudo stdin to transfer shell source;
    therefore it does NOT forward caller stdin to kcadm.sh. In particular,
    upstream commands that require reading JSON or other payloads from
    stdin are not supported by this adapter. Use kcadm options and files
    available on the remote host instead.

    Interactive kcadm prompts are not supported. Provide its native
    authentication information through the approved environment/options
    or its own existing session configuration. kcadm.config is owned by
    the effective remote execution user, not by this module.

SECURITY
    The remote shell source contains the quoted password during transport.
    Never enable debugging that dumps SSH stdin or the generated script.
    The module disables shell xtrace in its own execution and does not log
    secrets or persist them to files. As with any process environment,
    sufficiently privileged users may inspect the running process.
    Arguments supplied to kcadm itself may carry sensitive information
    and should follow Keycloak's own security guidance.

DEPENDENCIES
    rsudo.lib.sh
    POSIX shell on local and remote hosts
    Official kcadm.sh and its runtime on the selected remote host

    No dependency on rsudo-mod-keycloaklegacy.lib.sh or legacy REST/OAuth
    administration code.
