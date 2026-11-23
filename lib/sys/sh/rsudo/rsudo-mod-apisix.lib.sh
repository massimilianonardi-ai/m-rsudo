# Traditional APISIX Admin API for rsudo.
# Independent from the unchanged rsudo-mod-apisixlegacy.lib.sh.
rsudo_mod_apisix__error() { printf 'rsudo apisix: %s\n' "$1" >&2; return 64; }

rsudo_mod_apisix__quote()
(
  set +x
  value=$1
  printf "'"
  while :
  do
    case $value in
      *"'"*)
        printf '%s' "${value%%"'"*}"
        printf '%s' "'\\''"
        value=${value#*"'"}
        ;;
      *) printf '%s' "$value"; break ;;
    esac
  done
  printf "'"
)

rsudo_mod_apisix__json()
{
  printf '"'
  printf '%s' "$1" | LC_ALL=C od -An -tu1 | LC_ALL=C awk '
  { for (i=1; i<=NF; i++) {
      c=$i+0
      if (c==34) printf "\\\""
      else if (c==92) printf "\\\\"
      else if (c<32) printf "\\u%04x", c
      else printf "%c", c
  }}'
  printf '"'
}

# Compatibility with the former default admin credential source.
rsudo_mod_apisix_key()
(
  set +x
  config=${RSUDO_APISIX_CONFIG_PATH:-/usr/local/apisix/conf/config.yaml}
  case $config in
    /*) : ;;
    *) rsudo_mod_apisix__error 'config path must be absolute'; exit $? ;;
  esac
  {
    printf 'set +x\nconfig='
    rsudo_mod_apisix__quote "$config"
    printf '\n'
    cat <<'APISIX_KEY_REMOTE'
[ -r "$config" ] || { printf '%s\n' 'rsudo apisix: config not readable' >&2; exit 66; }
awk '
  /^[[:space:]]*admin_key:[[:space:]]*$/ { block=1; next }
  block && /^[[:space:]]*-[[:space:]]*name:/ {
    name=$0
    sub(/^.*name:[[:space:]]*/, "", name)
    gsub(/["\047[:space:]]/, "", name)
    admin=(name=="admin"); next
  }
  block && admin && /^[[:space:]]*key:[[:space:]]*/ {
    key=$0; sub(/^[[:space:]]*key:[[:space:]]*/, "", key)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
    if (key ~ /^".*"$/ || key ~ /^\047.*\047$/) key=substr(key,2,length(key)-2)
    if (key!="") { print key; found=1; exit }
  }
  END { if (!found) exit 1 }
' "$config" || { printf '%s\n' 'rsudo apisix: admin key not found; use APISIX_KEY' >&2; exit 67; }
APISIX_KEY_REMOTE
  } | RSUDO_INTERACTIVE=false rsudo
)

rsudo_mod_apisix_keyset()
{
  [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'keyset VARIABLE'; return $?; }
  case $1 in
    ''|[0-9]*|*[!A-Za-z0-9_]*)
      rsudo_mod_apisix__error 'invalid keyset variable'; return $? ;;
  esac
  _rsudo_apikey=$(rsudo_mod_apisix_key) || return $?
  eval "$1=\$_rsudo_apikey"
}

# api RESOURCE [METHOD [JSON]]
rsudo_mod_apisix_api()
(
  set +x
  [ "$#" -ge 1 ] && [ "$#" -le 3 ] && [ -n "$1" ] ||
    { rsudo_mod_apisix__error 'api RESOURCE [METHOD [JSON]]'; exit $?; }
  resource=$1; method=${2:-GET}
  case $method in GET|PUT|POST|PATCH|DELETE) : ;;
    *) rsudo_mod_apisix__error 'invalid HTTP method'; exit $? ;;
  esac
  base=${APISIX_ADMIN_URL:-http://127.0.0.1:9180/apisix/admin}
  case $base in http://*|https://*) : ;;
    *) rsudo_mod_apisix__error 'invalid Admin API URL'; exit $? ;;
  esac
  base=${base%/}
  secret=${APISIX_KEY-}
  [ -n "$secret" ] || secret=$(rsudo_mod_apisix_key) || exit $?
  [ -n "$secret" ] || { rsudo_mod_apisix__error 'empty admin key'; exit $?; }
  cr=$(printf '\r')
  case $secret in
    *'
'*|*"$cr"*) rsudo_mod_apisix__error 'admin key contains newline'; exit $? ;;
  esac
  {
    printf 'set +x\nset --\n'
    for value in "$base" "$resource" "$method" "$secret" "${3-}"
    do
      printf 'set -- "$@" '
      rsudo_mod_apisix__quote "$value"
      printf '\n'
    done
    printf 'body_set='
    [ "$#" -eq 3 ] && printf 'yes\n' || printf 'no\n'
    cat <<'APISIX_REMOTE'
base=$1; resource=$2; method=$3; key=$4; body=$5
set --
case $resource in /*) resource=${resource#/} ;; esac
# File descriptor 3 keeps the admin key out of curl process arguments.
exec 3<<APISIX_HEADER
X-API-KEY: $key
APISIX_HEADER
unset key
command -v curl >/dev/null 2>&1 ||
  { printf '%s\n' 'rsudo apisix: remote curl unavailable' >&2; exit 69; }
set -- curl --silent --show-error --fail --include --globoff --request "$method" --header '@/dev/fd/3' --header 'Content-Type: application/json' "$base/$resource"
if [ "$body_set" = yes ]
then
  printf '%s' "$body" | "$@" --data-binary @-
else
  "$@" </dev/null
fi
APISIX_REMOTE
  } | RSUDO_INTERACTIVE=false rsudo
)

rsudo_mod_apisix_get()  { rsudo_mod_apisix_api "${1-}" GET; }
rsudo_mod_apisix_put()  { rsudo_mod_apisix_api "${1-}" PUT "${2-}"; }
rsudo_mod_apisix_post() { rsudo_mod_apisix_api "${1-}" POST "${2-}"; }
rsudo_mod_apisix_del()  { rsudo_mod_apisix_api "${1-}" DELETE; }

# Public delete commands retain the former names/argument order.
rsudo_mod_apisix_delete()
{
  [ "$#" -eq 2 ] || { rsudo_mod_apisix__error 'delete TYPE ID'; return $?; }
  case $1 in
    service) rsudo_mod_apisix_del "services/$2" ;;
    route) rsudo_mod_apisix_del "routes/$2" ;;
    stream_route) rsudo_mod_apisix_del "stream_routes/$2" ;;
    upstream) rsudo_mod_apisix_del "upstreams/$2" ;;
    consumer) rsudo_mod_apisix_del "consumers/$2" ;;
    consumer_group) rsudo_mod_apisix_del "consumer_groups/$2" ;;
    ssl) rsudo_mod_apisix_del "ssls/$2" ;;
    global_rule) rsudo_mod_apisix_del "global_rules/$2" ;;
    plugin_metadata) rsudo_mod_apisix_del "plugin_metadata/$2" ;;
    plugin_config) rsudo_mod_apisix_del "plugin_configs/$2" ;;
    secret) rsudo_mod_apisix_del "secrets/$2" ;;
    proto) rsudo_mod_apisix_del "protos/$2" ;;
    *) rsudo_mod_apisix__error 'unknown delete type'; return $? ;;
  esac
}
rsudo_mod_apisix_delete_service() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "services/$1"; }
rsudo_mod_apisix_delete_route() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "routes/$1"; }
rsudo_mod_apisix_delete_stream_route() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "stream_routes/$1"; }
rsudo_mod_apisix_delete_upstream() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "upstreams/$1"; }
rsudo_mod_apisix_delete_consumer() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "consumers/$1"; }
rsudo_mod_apisix_delete_consumer_group() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "consumer_groups/$1"; }
rsudo_mod_apisix_delete_ssl() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "ssls/$1"; }
rsudo_mod_apisix_delete_global_rule() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "global_rules/$1"; }
rsudo_mod_apisix_delete_plugin_metadata() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "plugin_metadata/$1"; }
rsudo_mod_apisix_delete_plugin_config() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "plugin_configs/$1"; }
rsudo_mod_apisix_delete_secret() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "secrets/$1"; }
rsudo_mod_apisix_delete_proto() { [ "$#" -eq 1 ] || { rsudo_mod_apisix__error 'expected ID'; return $?; }; rsudo_mod_apisix_del "protos/$1"; }

rsudo_mod_apisix_create()
{
  [ "$#" -ge 1 ] || { rsudo_mod_apisix__error 'create TYPE ...'; return $?; }
  case $1 in
    generic|upstream|upstream_simple|service|service_simple|service_standard|route|route_simple|route_map|route_authn|route_authn_authz|global_rule)
      kind=$1; shift; "rsudo_mod_apisix_create_$kind" "$@"
      ;;
    *) rsudo_mod_apisix__error 'unknown create type'; return $? ;;
  esac
}

rsudo_mod_apisix__named()
{
  printf '{"id":%s,"name":%s,%s}' "$(rsudo_mod_apisix__json "$1")" "$(rsudo_mod_apisix__json "$1")" "$2"
}

rsudo_mod_apisix_create_generic()
(
  [ "$#" -eq 3 ] && [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] ||
    { rsudo_mod_apisix__error 'create_generic COLLECTION ID JSON-FIELDS'; exit $?; }
  data=$(printf '{"id":%s,%s}' "$(rsudo_mod_apisix__json "$2")" "$3")
  rsudo_mod_apisix_put "$1/$2" "$data"
)

rsudo_mod_apisix_create_upstream()
(
  [ "$#" -eq 2 ] && [ -n "$1" ] && [ -n "$2" ] ||
    { rsudo_mod_apisix__error 'create_upstream ID JSON-FIELDS'; exit $?; }
  body=$(rsudo_mod_apisix__named "$1" "$2")
  rsudo_mod_apisix_put "upstreams/$1" "$body"
)

rsudo_mod_apisix_create_service()
(
  [ "$#" -eq 2 ] && [ -n "$1" ] && [ -n "$2" ] ||
    { rsudo_mod_apisix__error 'create_service ID JSON-FIELDS'; exit $?; }
  body=$(rsudo_mod_apisix__named "$1" "$2")
  rsudo_mod_apisix_put "services/$1" "$body"
)

rsudo_mod_apisix_create_upstream_simple()
(
  [ "$#" -eq 3 ] || { rsudo_mod_apisix__error 'create_upstream_simple ID SCHEME HOST:PORT'; exit $?; }
  scheme=$(rsudo_mod_apisix__json "$2"); node=$(rsudo_mod_apisix__json "$3")
  rsudo_mod_apisix_create_upstream "$1" "\"scheme\":$scheme,\"retries\":1,\"type\":\"roundrobin\",\"nodes\":{$node:1}"
)

rsudo_mod_apisix_create_service_simple()
(
  [ "$#" -eq 3 ] || { rsudo_mod_apisix__error 'create_service_simple ID SCHEME HOST:PORT'; exit $?; }
  scheme=$(rsudo_mod_apisix__json "$2"); node=$(rsudo_mod_apisix__json "$3")
  rsudo_mod_apisix_create_service "$1" "\"upstream\":{\"scheme\":$scheme,\"retries\":1,\"type\":\"roundrobin\",\"nodes\":{$node:1}}"
)

rsudo_mod_apisix_create_service_standard()
(
  [ "$#" -eq 3 ] || { rsudo_mod_apisix__error 'create_service_standard ID UPSTREAM_ID PLUGINS'; exit $?; }
  upstream=$(rsudo_mod_apisix__json "$2")
  rsudo_mod_apisix_create_service "$1" "\"upstream_id\":$upstream,\"plugins\":{$3}"
)

rsudo_mod_apisix_json_string_or_array()
(
  [ "$#" -eq 3 ] && [ -n "$3" ] ||
    { rsudo_mod_apisix__error 'json_string_or_array KEY ARRAY-KEY VALUES'; exit $?; }
  single=$1; plural=$2
  set -f
  set -- $3
  if [ "$#" -eq 1 ]; then
    printf '%s:%s' "$(rsudo_mod_apisix__json "$single")" "$(rsudo_mod_apisix__json "$1")"
  else
    printf '%s:[' "$(rsudo_mod_apisix__json "$plural")"
    comma=
    for value; do printf '%s%s' "$comma" "$(rsudo_mod_apisix__json "$value")"; comma=,; done
    printf ']'
  fi
)

rsudo_mod_apisix_create_route()
(
  [ "$#" -eq 3 ] && [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] ||
    { rsudo_mod_apisix__error 'create_route ID URIS JSON-FIELDS'; exit $?; }
  id=$(rsudo_mod_apisix__json "$1")
  uris=$(rsudo_mod_apisix_json_string_or_array uri uris "$2") || exit $?
  body=$(printf '{"id":%s,"name":%s,%s,%s}' "$id" "$id" "$uris" "$3")
  rsudo_mod_apisix_put "routes/$1" "$body"
)

rsudo_mod_apisix_create_route_simple()
{
  [ "$#" -eq 3 ] || { rsudo_mod_apisix__error 'create_route_simple ID URIS SERVICE'; return $?; }
  rsudo_mod_apisix_create_route "$1" "$2" "\"service_id\":$(rsudo_mod_apisix__json "$3")"
}

rsudo_mod_apisix_create_route_map()
(
  [ "$#" -eq 4 ] || { rsudo_mod_apisix__error 'create_route_map ID URI MAPPED SERVICE'; exit $?; }
  pattern=$(rsudo_mod_apisix__json "^/$2/(.*)")
  # APISIX replacement must contain a literal regex capture $1.
  replacement=$(rsudo_mod_apisix__json "/$3/$""1")
  rewrite="\"proxy-rewrite\":{\"headers\":{\"remove\":[\"Cookie\"]},\"regex_uri\":[$pattern,$replacement]}"
  rsudo_mod_apisix_create_route "$1" "/$2 /$2/*" "\"service_id\":$(rsudo_mod_apisix__json "$4"),\"plugins\":{$rewrite}"
)

rsudo_mod_apisix_create_global_rule()
(
  [ "$#" -eq 2 ] || { rsudo_mod_apisix__error 'create_global_rule ID PLUGINS'; exit $?; }
  rsudo_mod_apisix_put "global_rules/$1" "{\"id\":$(rsudo_mod_apisix__json "$1"),\"plugins\":{$2}}"
)

# Legacy-compatible Keycloak/openid-connect plugin composition, without
# coupling this module to rsudo-mod-keycloak or to the APISIX legacy code.
APISIX_PLUGIN_CONF_RESPONSE_REWRITE_USERINFO='"response-rewrite":{"headers":{"X-Userinfo":"$http_x_userinfo"}}'
APISIX_GLOBAL_RULE_CONF_RESPONSE_REWRITE_FLUSH_COOKIES='"response-rewrite":{"headers":{"Set-Cookie":"session=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT; HttpOnly; Secure; SameSite=Lax"},"vars":[["status","~=",404],["status",">=",400],["status","<",500]]}'

rsudo_mod_apisix__authn()
{
  [ -n "${APISIX_KEYCLOAK_CLIENT_ID-}" ] && [ -n "${APISIX_KEYCLOAK_AUTHN_DISCOVERY_URL-}" ] ||
    { rsudo_mod_apisix__error 'set_auth_vars must be called first'; return $?; }
  printf '"openid-connect":{"client_id":%s,"client_secret":%s,"discovery":%s,"redirect_uri":%s,"scope":"openid email profile","use_pkce":true,"bearer_only":false,"access_token_in_authorization_header":true,"set_userinfo_header":true,"session":{"redis":{},"secret":%s}}' \
    "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_CLIENT_ID")" "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_CLIENT_SECRET")" \
    "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_AUTHN_DISCOVERY_URL")" "$(rsudo_mod_apisix__json "$APISIX_BASE_URL/$1/callback")" \
    "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_CLIENT_SESSION_SECRET")"
}
rsudo_mod_apisix__authz()
{
  printf '"authz-keycloak":{"client_id":%s,"client_secret":%s,"discovery":%s,"policy_enforcement_mode":"ENFORCING","lazy_load_paths":false,"http_method_as_scope":false,"permissions":[%s],"ssl_verify":true}' \
    "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_CLIENT_ID")" "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_CLIENT_SECRET")" \
    "$(rsudo_mod_apisix__json "$APISIX_KEYCLOAK_AUTHZ_DISCOVERY_URL")" "$(rsudo_mod_apisix__json "$1")"
}

rsudo_mod_apisix_set_auth_vars()
{
  [ "$#" -ge 7 ] && [ "$#" -le 8 ] ||
    { rsudo_mod_apisix__error 'set_auth_vars HOST PORT KC_HOST KC_PORT REALM CLIENT_ID CLIENT_SECRET [SESSION_SECRET]'; return $?; }
  APISIX_HOST=$1; APISIX_PORT=$2
  APISIX_KEYCLOAK_HOST=$3; APISIX_KEYCLOAK_PORT=$4; APISIX_KEYCLOAK_REALM=$5
  APISIX_KEYCLOAK_CLIENT_ID=$6; APISIX_KEYCLOAK_CLIENT_SECRET=$7
  APISIX_KEYCLOAK_CLIENT_SESSION_SECRET=${8:-apisix_openid_connect_session_secret}
  if [ "$APISIX_PORT" = 443 ]; then APISIX_BASE_URL="https://$APISIX_HOST"
  else APISIX_BASE_URL="https://$APISIX_HOST:$APISIX_PORT"; fi
  if [ "$APISIX_KEYCLOAK_PORT" = 443 ]; then realm_base="https://$APISIX_KEYCLOAK_HOST"
  else realm_base="https://$APISIX_KEYCLOAK_HOST:$APISIX_KEYCLOAK_PORT"; fi
  APISIX_KEYCLOAK_REALM_URL="$realm_base/realms/$APISIX_KEYCLOAK_REALM"
  APISIX_KEYCLOAK_AUTHN_DISCOVERY_URL="$APISIX_KEYCLOAK_REALM_URL/.well-known/openid-configuration"
  APISIX_KEYCLOAK_AUTHZ_DISCOVERY_URL="$APISIX_KEYCLOAK_REALM_URL/.well-known/uma2-configuration"

  # Preserve template variables for callers using env_eval externally.
  APISIX_PLUGIN_CONF_KEYCLOAK_AUTHN_TEMPLATE=$(rsudo_mod_apisix__authn '${1}')
  APISIX_PLUGIN_CONF_KEYCLOAK_AUTHZ_TEMPLATE=$(rsudo_mod_apisix__authz '${1}')
  APISIX_PLUGIN_CONF_PROXY_REWRITE_TEMPLATE='"proxy-rewrite":{"headers":{"remove":["Cookie"]},"regex_uri":["^/${1}/(.*)","/$1"]}'
  APISIX_PLUGIN_CONF_CORS_USERINFO_TEMPLATE='"cors":{"allow_headers":"**","allow_origins":"${1}","expose_headers":"X-Userinfo","allow_methods":"GET,POST,PUT,DELETE,OPTIONS","allow_credential":true}'
}

rsudo_mod_apisix__auth_route()
(
  [ "$#" -eq 3 ] || [ "$#" -eq 4 ] ||
    { rsudo_mod_apisix__error 'auth route ID URI SERVICE [RESOURCE]'; exit $?; }
  [ -n "${APISIX_KEYCLOAK_AUTHN_DISCOVERY_URL-}" ] ||
    { rsudo_mod_apisix__error 'call set_auth_vars first'; exit $?; }
  authn=$(rsudo_mod_apisix__authn "authz/$2") || exit $?
  authz=
  [ "$#" -eq 4 ] && authz=",$(rsudo_mod_apisix__authz "$4")"
  pattern=$(rsudo_mod_apisix__json '^/authz/(.*)')
  replacement=$(rsudo_mod_apisix__json '/$1')
  origin=$(rsudo_mod_apisix__json "$APISIX_BASE_URL")
  plugins="$authn$authz,\"proxy-rewrite\":{\"headers\":{\"remove\":[\"Cookie\"]},\"regex_uri\":[$pattern,$replacement]},\"cors\":{\"allow_headers\":\"**\",\"allow_origins\":$origin,\"expose_headers\":\"X-Userinfo\",\"allow_methods\":\"GET,POST,PUT,DELETE,OPTIONS\",\"allow_credential\":true},$APISIX_PLUGIN_CONF_RESPONSE_REWRITE_USERINFO"
  rsudo_mod_apisix_create_route "$1" "/authz/$2 /authz/$2/*" "\"service_id\":$(rsudo_mod_apisix__json "$3"),\"plugins\":{$plugins}"
)
rsudo_mod_apisix_create_route_authn()
{
  [ "$#" -eq 3 ] || { rsudo_mod_apisix__error 'create_route_authn ID URI SERVICE'; return $?; }
  rsudo_mod_apisix__auth_route "$@"
}
rsudo_mod_apisix_create_route_authn_authz()
{
  [ "$#" -eq 4 ] || { rsudo_mod_apisix__error 'create_route_authn_authz ID URI SERVICE RESOURCE'; return $?; }
  rsudo_mod_apisix__auth_route "$@"
}
