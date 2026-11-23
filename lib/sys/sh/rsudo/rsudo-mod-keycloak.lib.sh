# Native Keycloak administration CLI adapter for rsudo.
# SSH/sudo transport is owned by rsudo; authentication is owned by kcadm.sh.

rsudo_mod_keycloak__shell_quote()
(
  set +x
  _kcadm_quote_value=$1
  printf "'"
  while :
  do
    case $_kcadm_quote_value in
      *"'"*)
        _kcadm_quote_prefix=${_kcadm_quote_value%%"'"*}
        printf '%s' "$_kcadm_quote_prefix"
        printf '%s' "'\\''"
        _kcadm_quote_value=${_kcadm_quote_value#*"'"}
        ;;
      *)
        printf '%s' "$_kcadm_quote_value"
        break
        ;;
    esac
  done
  printf "'"
)

rsudo_mod_keycloak_kcadm()
(
  set +x

  if [ -z "${RSUDO_KEYCLOAK_PATH-}" ]
  then
    printf '%s\n' 'rsudo keycloak: RSUDO_KEYCLOAK_PATH is required' >&2
    exit 64
  fi

  case $RSUDO_KEYCLOAK_PATH in
    /*) : ;;
    *)
      printf '%s\n' 'rsudo keycloak: RSUDO_KEYCLOAK_PATH must be an absolute remote path' >&2
      exit 64
      ;;
  esac

  # Generate remote shell source on stdin, not in SSH/sudo command arguments.
  # This transport reserves stdin for the script; kcadm stdin is unavailable.
  {
    cat <<'KCADM_REMOTE_HEADER'
set +x
KCADM_EXEC=
KCADM_REMOTE_HEADER
    printf 'KCADM_EXEC='
    rsudo_mod_keycloak__shell_quote "$RSUDO_KEYCLOAK_PATH"
    printf '\n'

    if [ "${KC_CLI_PASSWORD+x}" = x ]
    then
      printf 'KC_CLI_PASSWORD='
      rsudo_mod_keycloak__shell_quote "$KC_CLI_PASSWORD"
      printf '\nexport KC_CLI_PASSWORD\n'
    else
      printf 'unset KC_CLI_PASSWORD\n'
    fi

    printf 'set --'
    for _kcadm_arg
    do
      printf ' '
      rsudo_mod_keycloak__shell_quote "$_kcadm_arg"
    done
    printf '\n'

    cat <<'KCADM_REMOTE_RUN'
if [ ! -f "$KCADM_EXEC" ] || [ ! -x "$KCADM_EXEC" ]
then
  printf '%s\n' 'rsudo keycloak: remote kcadm executable not found or not executable' >&2
  exit 127
fi
exec "$KCADM_EXEC" "$@" </dev/null
KCADM_REMOTE_RUN
  } | RSUDO_INTERACTIVE=false rsudo
)
