#!/bin/sh
# Local mock checks for the exact two public APISIX Traditional functions.
# No SSH/sudo and no real APISIX instance is contacted.
set -eu
src=${0%/*}/../../lib/sys/sh/rsudo/rsudo-mod-apisix.lib.sh
. "$src"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/rsudo-apisix-test.XXXXXXXX")
trap 'rm -rf "$tmp"' 0 1 2 3 15

# Both APIs send source over stdin. Mock remote rsudo by executing sh -s.
rsudo()
(
  [ "$#" -eq 0 ] || exit 99
  [ "${RSUDO_INTERACTIVE-}" = false ] || exit 98
  /bin/sh -s
)
mkdir -p "$tmp/bin"
cat > "$tmp/bin/curl" <<'MOCK_CURL'
#!/bin/sh
method= url= header= body= has_body=no
while [ "$#" -gt 0 ]
do
  case $1 in
    --request) method=$2; shift 2 ;;
    --header)
      case $2 in
        @*) header=$(cat "${2#@}") ;;
      esac
      shift 2 ;;
    --data-binary) has_body=yes; body=$(cat); shift 2 ;;
    http://*|https://*) url=$1; shift ;;
    *) shift ;;
  esac
done
printf 'METHOD:%s\nURL:%s\nKEY:%s\nBODY_SET:%s\nBODY:%s\n' \
  "$method" "$url" "$header" "$has_body" "$body"
[ "$method" != DELETE ] || exit 22
MOCK_CURL
chmod +x "$tmp/bin/curl"
PATH="$tmp/bin:$PATH"; export PATH

# Only the two documented public functions may be exported.
[ "$(grep -c '^rsudo_mod_apisix_[a-zA-Z0-9_]*()' "$src")" -eq 2 ]
APISIX_KEY="secret with ' and \$(not-executed)"
got=$(rsudo_mod_apisix_rest PUT 'routes/demo?x=a&y=b' '{"uri":"/x", "value":"a'\''b"}')
printf '%s\n' "$got" | grep -Fqx 'METHOD:PUT'
printf '%s\n' "$got" | grep -Fqx 'URL:http://127.0.0.1:9180/apisix/admin/routes/demo?x=a&y=b'
printf '%s\n' "$got" | grep -Fqx "KEY:X-API-KEY: $APISIX_KEY"
printf '%s\n' "$got" | grep -Fqx 'BODY_SET:yes'
printf '%s\n' "$got" | grep -Fqx 'BODY:{"uri":"/x", "value":"a'\''b"}'
got=$(rsudo_mod_apisix_rest GET routes)
printf '%s\n' "$got" | grep -Fqx 'BODY_SET:no'
set +e
rsudo_mod_apisix_rest DELETE routes/demo >/dev/null 2>&1
delete_rc=$?
(rsudo_mod_apisix_rest FOO routes) >/dev/null 2>&1
invalid_rc=$?
(unset APISIX_KEY; rsudo_mod_apisix_rest GET routes) >/dev/null 2>&1
missing_rc=$?
rsudo_mod_apisix_key relative/file.yaml >/dev/null 2>&1
path_rc=$?
set -e
[ "$delete_rc" -eq 22 ]
[ "$invalid_rc" -eq 64 ]
[ "$missing_rc" -eq 64 ]
[ "$path_rc" -eq 64 ]

# Exercise a standard APISIX Traditional admin_key block.
mkdir -p "$tmp/conf space"
cat > "$tmp/conf space/config.yaml" <<'APISIX_CONFIG'
deployment:
  admin:
    admin_key:
      - name: admin
        key: custom-admin-key
        role: admin
      - name: viewer
        key: viewer-key
        role: viewer
APISIX_CONFIG
got=$(rsudo_mod_apisix_key "$tmp/conf space/config.yaml")
[ "$got" = custom-admin-key ]
APISIX_KEY=$got
got=$(rsudo_mod_apisix_rest GET upstreams)
printf '%s\n' "$got" | grep -Fqx 'KEY:X-API-KEY: custom-admin-key'
set +e
rsudo_mod_apisix_key "/nonexistent/config.yaml" >/dev/null 2>&1
notfound_rc=$?
set -e
[ "$notfound_rc" -eq 66 ]
printf '%s\n' 'rsudo APISIX two-API local tests: PASS'
