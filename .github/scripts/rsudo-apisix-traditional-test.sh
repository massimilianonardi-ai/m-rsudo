#!/bin/sh
# Non-network behavior checks; no real SSH/sudo/APISIX server is contacted.
set -eu
root=${0%/*}/../..
. "$root/lib/sys/sh/rsudo/rsudo-mod-apisix.lib.sh"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/apisix-test.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp/bin"
cat >"$tmp/bin/curl" <<'STUB'
#!/bin/sh
method=none; url=none; header=none; data=none
while [ "$#" -gt 0 ]; do
  case $1 in
    --request) method=$2; shift 2 ;;
    --header)
      case $2 in @*) header=$(cat "${2#@}") ;; esac
      shift 2 ;;
    --data-binary) data=$(cat); shift 2 ;;
    http://*|https://*) url=$1; shift ;;
    *) shift ;;
  esac
done
printf 'METHOD:%s\nURL:%s\nHEADER:%s\nDATA:%s\n' "$method" "$url" "$header" "$data"
[ "$method" != DELETE ] || exit 22
STUB
chmod +x "$tmp/bin/curl"
PATH="$tmp/bin:$PATH"; export PATH
rsudo()
(
  [ "$#" -eq 0 ] || exit 99
  [ "${RSUDO_INTERACTIVE-}" = false ] || exit 98
  /bin/sh -s
)
APISIX_KEY="a'b-special"
output=$(rsudo_mod_apisix_api 'routes/demo' PUT '{"uri":"/demo"}')
printf '%s\n' "$output" | grep -Fqx 'METHOD:PUT'
printf '%s\n' "$output" | grep -Fqx 'URL:http://127.0.0.1:9180/apisix/admin/routes/demo'
printf '%s\n' "$output" | grep -Fqx "HEADER:X-API-KEY: $APISIX_KEY"
printf '%s\n' "$output" | grep -Fqx 'DATA:{"uri":"/demo"}'
output=$(rsudo_mod_apisix_create_route_simple id '/x /y' service)
printf '%s\n' "$output" | grep -Fq '"uris":["/x","/y"]'
printf '%s\n' "$output" | grep -Fq '"service_id":"service"'
set +e
rsudo_mod_apisix_del routes/id >/dev/null 2>&1
delete_status=$?
rsudo_mod_apisix_api routes BADMETHOD >/dev/null 2>&1
invalid_status=$?
set -e
[ "$delete_status" -eq 22 ]
[ "$invalid_status" -eq 64 ]

# Configuration fallback: recognize the named admin entry of config.yaml.
mkdir -p "$tmp/conf"
cat > "$tmp/conf/config.yaml" <<'YAML'
deployment:
  admin:
    admin_key:
      - name: "viewer"
        key: viewer-only
      - name: "admin"
        key: "config-admin-test"
YAML
unset APISIX_KEY
RSUDO_APISIX_CONFIG_PATH="$tmp/conf/config.yaml"
value=$(rsudo_mod_apisix_key)
[ "$value" = config-admin-test ]
output=$(rsudo_mod_apisix_get routes)
printf '%s\n' "$output" | grep -Fqx 'HEADER:X-API-KEY: config-admin-test'

# Recreated auth helpers retain the route and plugin contract.
APISIX_KEY='fake-secret'
rsudo_mod_apisix_set_auth_vars gateway.test 443 keycloak.test 443 master client-id client-secret
output=$(rsudo_mod_apisix_create_route_authn_authz protected users service login-resource)
printf '%s\n' "$output" | grep -Fq '"openid-connect":{'
printf '%s\n' "$output" | grep -Fq '"authz-keycloak":{'
printf '%s\n' "$output" | grep -Fq '"permissions":["login-resource"]'
printf '%s\n' "$output" | grep -Fq '"service_id":"service"'
printf '%s\n' 'APISIX Traditional adapter mock: PASS'
