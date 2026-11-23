# APISIX Traditional Admin API: exactly two public operations, rest and key.
# rsudo owns SSH/sudo; curl owns HTTP; the legacy module remains independent.

# Private POSIX shell-value encoder used only for scripts sent over stdin.
_rs_apisix_sq()
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

# rsudo apisix rest METHOD RESOURCE [BODY]
# APISIX_KEY is mandatory. No implicit key lookup, helper CRUD or new tools.
rsudo_mod_apisix_rest()
(
  set +x

  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ] || [ -z "$2" ]
  then
    printf '%s\n' 'rsudo apisix rest: expected METHOD RESOURCE [BODY]' >&2
    exit 64
  fi

  case $1 in
    GET|POST|PUT|PATCH|DELETE|HEAD|OPTIONS) : ;;
    *)
      printf '%s\n' 'rsudo apisix rest: unsupported HTTP method' >&2
      exit 64
      ;;
  esac

  if [ -z "${APISIX_KEY-}" ]
  then
    printf '%s\n' 'rsudo apisix rest: APISIX_KEY is required' >&2
    exit 64
  fi

  _apisix_cr=$(printf '\r')
  case $APISIX_KEY in
    *'
'*|*"$_apisix_cr"*)
      printf '%s\n' 'rsudo apisix rest: invalid APISIX_KEY (CR/LF)' >&2
      exit 64
      ;;
  esac

  _apisix_base=${APISIX_ADMIN_URL:-http://127.0.0.1:9180/apisix/admin}
  case $_apisix_base in
    http://*|https://*) : ;;
    *)
      printf '%s\n' 'rsudo apisix rest: invalid APISIX_ADMIN_URL' >&2
      exit 64
      ;;
  esac

  case $2 in
    http://*|https://*)
      printf '%s\n' 'rsudo apisix rest: RESOURCE must be an Admin API relative path' >&2
      exit 64
      ;;
  esac

  {
    printf 'set +x\n'
    printf '_apisix_method='
    _rs_apisix_sq "$1"
    printf '\n_apisix_resource='
    _rs_apisix_sq "$2"
    printf '\n_apisix_base='
    _rs_apisix_sq "$_apisix_base"
    printf '\n_apisix_key='
    _rs_apisix_sq "$APISIX_KEY"
    printf '\n_apisix_has_body='
    if [ "$#" -eq 3 ]; then printf 'yes\n'; else printf 'no\n'; fi
    if [ "$#" -eq 3 ]
    then
      printf '_apisix_body='
      _rs_apisix_sq "$3"
      printf '\n'
    fi

    cat <<'APISIX_REST_REMOTE'
# Keep the API key off the curl and rsudo command lines.
exec 3<<APISIX_HEADER
X-API-KEY: $_apisix_key
APISIX_HEADER
unset _apisix_key

command -v curl >/dev/null 2>&1 ||
  { printf '%s\n' 'rsudo apisix rest: curl unavailable remotely' >&2; exit 69; }

case $_apisix_resource in
  /*) _apisix_resource=${_apisix_resource#/} ;;
esac
_apisix_base=${_apisix_base%/}
set -- curl --silent --show-error --fail --include --globoff \
  --request "$_apisix_method" --header '@/dev/fd/3' \
  --header 'Content-Type: application/json' \
  "$_apisix_base/$_apisix_resource"

if [ "$_apisix_has_body" = yes ]
then
  printf '%s' "$_apisix_body" | "$@" --data-binary @-
else
  "$@" </dev/null
fi
APISIX_REST_REMOTE
  } | RSUDO_INTERACTIVE=false rsudo
)

# rsudo apisix key /ABSOLUTE/PATH/TO/config.yaml
# Adapts the original legacy admin-key extraction pipeline, taking its
# formerly hard-coded config file path as the only explicit argument.
rsudo_mod_apisix_key()
(
  set +x
  if [ "$#" -ne 1 ]
  then
    printf '%s\n' 'rsudo apisix key: expected absolute path to config.yaml' >&2
    exit 64
  fi
  case $1 in
    /*) : ;;
    *)
      printf '%s\n' 'rsudo apisix key: config path must be absolute' >&2
      exit 64
      ;;
  esac

  {
    printf 'set +x\n_apisix_config='
    _rs_apisix_sq "$1"
    printf '\n'

    cat <<'APISIX_KEY_REMOTE'
if [ ! -f "$_apisix_config" ] || [ ! -r "$_apisix_config" ]
then
  printf '%s\n' 'rsudo apisix key: remote config.yaml not readable' >&2
  exit 66
fi

# Original rsudo-mod-apisixlegacy key() extraction, adapted to the
# operator-supplied path rather than /usr/local/apisix/conf/config.yaml.
ADMIN_KEY_PREFIX="$(sed -n 's/admin_key:.*//p' "$_apisix_config")" || exit 67
ADMIN_KEY="$(sed "s/$ADMIN_KEY_PREFIX//" "$_apisix_config" |
  sed -n '/admin_key:/,/^[[:lower:]]/{//!p;}' |
  tr '\n' '|' |
  sed -e 's/ //g' -e 's/.*admin|//' -e 's/|.*//' -e 's/key://')" || exit 67

if [ -z "$ADMIN_KEY" ]
then
  printf '%s\n' 'rsudo apisix key: admin key not found in config.yaml' >&2
  exit 67
fi
printf '%s\n' "$ADMIN_KEY"
APISIX_KEY_REMOTE
  } | RSUDO_INTERACTIVE=false rsudo
)
