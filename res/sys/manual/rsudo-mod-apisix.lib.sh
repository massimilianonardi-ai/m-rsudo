NAME
    rsudo-mod-apisix.lib.sh — minimal APISIX Traditional remote interface

SYNOPSIS
    rsudo [rsudo-options...] apisix rest METHOD RESOURCE [BODY]
    rsudo [rsudo-options...] apisix key /absolute/path/to/config.yaml

DESCRIPTION
    Exactly two public operations. The rest operation forwards HTTP
    requests to APISIX Traditional's native Admin API using the existing
    rsudo SSH/sudo transport and remote curl. No additional products or
    REST resource helper APIs are installed or implemented.

    The key operation reads the admin key from a remote APISIX config.yaml
    using the original legacy extraction approach, adapted to accept an
    absolute remote path. The key is printed to stdout for capture.

    The independent rsudo-mod-apisixlegacy.lib.sh remains unchanged and
    accessible separately through the legacy module dispatcher. This new
    module does not source it or implement its many individual helpers.

ENVIRONMENT
    APISIX_KEY
        Mandatory for rest. Read from the caller's shell environment.
        The value is transmitted in rsudo stdin and supplied to curl
        through a protected inherited file descriptor, not argv.
        It is NEVER implicitly fetched by rest. The key must be nonempty
        and must not contain CR or LF.

    APISIX_ADMIN_URL
        Optional complete Admin API base URL as resolved on the rsudo
        remote host. Default http://127.0.0.1:9180/apisix/admin.

REST INTERFACE
    METHOD
        GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS.
    RESOURCE
        Relative APISIX Admin API path, such as routes or routes/example.
        An optional leading / is accepted. Query strings are preserved.
        A full HTTP(S) URL is rejected.
    BODY
        Optional exact request body, as a shell argument. The wrapper
        sends it with curl --data-binary @-. Missing and empty BODY differ.
        Since rsudo owns stdin for its remote shell source, this API does
        not accept request bodies piped from the caller's stdin.

    Results contain the original HTTP response headers and body for
    successful responses. curl errors propagate as nonzero status,
    including status 22 for HTTP >=400.

KEY EXTRACTION
    The path must refer to a regular, readable config.yaml file on the
    remote rsudo execution host. It must be absolute; there is no default
    or automatic discovery. The function prints the configured legacy
    administrator key. It does not set the caller's APISIX_KEY itself.

EXAMPLES
    APISIX_KEY=$(rsudo apisix key /usr/local/apisix/conf/config.yaml)
    export APISIX_KEY

    rsudo apisix rest GET routes
    rsudo apisix rest GET routes/demo
    rsudo apisix rest PUT routes/demo '{"uri":"/demo","upstream_id":"backend"}'
    rsudo apisix rest PATCH routes/demo '{"status":0}'
    rsudo apisix rest DELETE routes/demo

SECURITY / BOUNDARIES
    REST password and body travel inside rsudo stdin remote source, not
    as SSH/sudo/curl argv. Caller command arguments may still be recorded
    by the outer rsudo dispatcher and caller's shell history: do not use
    BODY for secrets unless that logging exposure has been addressed.
    Avoid debugging mechanisms that log stdin or generated shell source.

    Requires a POSIX shell plus curl (including -H @/dev/fd/3) on the
    remote target. The key extraction uses the existing POSIX awk utility.
    The module does not verify the active APISIX deployment mode: only
    Traditional is supported by contract. No real remote deployment or
    live APISIX behavior is claimed solely from mock tests.
