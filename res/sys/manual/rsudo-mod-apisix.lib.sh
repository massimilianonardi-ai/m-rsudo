NAME
    rsudo-mod-apisix.lib.sh — APISIX Traditional Admin API through rsudo

SYNOPSIS
    rsudo [rsudo-options...] apisix api RESOURCE [METHOD [JSON]]
    rsudo [rsudo-options...] apisix get RESOURCE
    rsudo [rsudo-options...] apisix put RESOURCE JSON
    rsudo [rsudo-options...] apisix post RESOURCE JSON
    rsudo [rsudo-options...] apisix del RESOURCE
    rsudo [rsudo-options...] apisix create TYPE ...
    rsudo [rsudo-options...] apisix delete TYPE ID

DESCRIPTION
    Reimplemented administration of APISIX Traditional (etcd-backed) only.
    This implementation is independent from the preserved and unmodified
    rsudo-mod-apisixlegacy.lib.sh, which remains separately dispatchable via
    rsudo apisixlegacy <operation>. No Standalone or Decoupled support.

    All operations use the native APISIX Admin API via curl under the existing
    non-interactive rsudo SSH/sudo transport. No additional software is
    introduced. User-provided resources are forwarded as paths under the
    configured Admin API base. The module does not edit etcd directly.

ENVIRONMENT
    APISIX_ADMIN_URL
        Optional Admin API base URL on the remote host; default
        http://127.0.0.1:9180/apisix/admin. The operator must select a
        Traditional APISIX instance. This module does not automatically
        discover or verify the remote deployment mode.

    APISIX_KEY
        Optional explicit Admin API key. If not supplied, key() attempts to
        retrieve the named admin entry from the remote original default file
        /usr/local/apisix/conf/config.yaml. This best-effort YAML extraction
        is for backward compatibility; use APISIX_KEY for custom deployments.

    RSUDO_APISIX_CONFIG_PATH
        Optional absolute path to the config.yaml file for key() fallback.

PUBLIC LEGACY-COMPATIBLE OPERATIONS
    set_auth_vars, json_string_or_array, key, keyset, api, get, put, post,
    del, delete, delete_service, delete_route, delete_stream_route,
    delete_upstream, delete_consumer, delete_consumer_group, delete_ssl,
    delete_global_rule, delete_plugin_metadata, delete_plugin_config,
    delete_secret, delete_proto, create, create_generic, create_upstream,
    create_upstream_simple, create_service, create_service_simple,
    create_service_standard, create_route, create_route_simple,
    create_route_map, create_route_authn, create_route_authn_authz,
    create_global_rule.

    Named create operations use the official resource-specific PUT by ID
    endpoint. The input signatures and JSON-field-fragment conventions of
    the legacy entrypoints remain available. Invalid field fragments are
    rejected by APISIX, not silently interpreted by this adapter.

    An HTTP error yields curl status 22 instead of reporting false success.
    Native curl response headers and body are included for successful calls.
    Connection, authentication and JSON validation failures are reported
    through stderr/nonzero status.

SECURITY
    APISIX_KEY and JSON payloads are transmitted inside a remote shell script
    via rsudo stdin, not in SSH/sudo or curl arguments. The remote process
    gives the key to curl using -H @/dev/fd/3; it reads JSON body via stdin.
    Do not enable tracing of rsudo stdin, and note that outer rsudo module
    dispatcher logs may contain public command arguments such as JSON.

    Requires remote curl >= 7.55 with -H @/dev/fd/3 and a POSIX shell.
    rsudo stdin is reserved for transporting remote shell source; commands
    requiring extra caller stdin are not supported.

VERIFICATION
    Mock integration tests and source-package tests are separate from real
    SSH/sudo and live APISIX Traditional acceptance.
