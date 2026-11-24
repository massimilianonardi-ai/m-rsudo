# Deployment interactive interface. Source only: no action at load time.
# Call rsudo_deploy_menu from an initialized m shell.
#
# rsudo-admin deliberately calls this from a subshell so its non-exported
# rsudo credential groups are available without changing admin's state.

_rsudo_deploy_groups()
(
  set |
  while IFS= read -r rsudo_deploy_line
  do
    case $rsudo_deploy_line in
      RSUDO_CREDENTIALS_GROUP_*_HOST=*)
        rsudo_deploy_name=${rsudo_deploy_line%%=*}
        rsudo_deploy_group=${rsudo_deploy_name#RSUDO_CREDENTIALS_GROUP_}
        rsudo_deploy_group=${rsudo_deploy_group%_HOST}
        if valid_shell_identifier "$rsudo_deploy_group"
        then
          printf '%s\n' "$rsudo_deploy_group"
        fi
      ;;
    esac
  done | LC_ALL=C command -p sort -u
)

_rsudo_deploy_choose_group()
{
  rsudo_deploy_groups=$(_rsudo_deploy_groups) || return 2
  [ -n "$rsudo_deploy_groups" ] || return 3

  rsudo_deploy_old_ifs=$IFS
  IFS='
'
  set --
  for rsudo_deploy_group in $rsudo_deploy_groups
  do
    set -- "$@" "${rsudo_deploy_group}@:=Credential group: ${rsudo_deploy_group}"
  done
  IFS=$rsudo_deploy_old_ifs

  rsudo_deploy_result=$(command -- menu \
    -H 'Deployment — select credential group' \
    -F 'Enter: select | Escape: back' \
    -- "$@")
  rsudo_deploy_status=$?
  case $rsudo_deploy_status in
    0) ;;
    1) return 1 ;;
    *) return "$rsudo_deploy_status" ;;
  esac

  eval "set -- $rsudo_deploy_result" || return 2
  [ "$#" -eq 2 ] && [ "$1" = enter ] || return 2
  valid_shell_identifier "$2" || return 2
  rsudo_deploy_selected_group=$2
  return 0
}

_rsudo_deploy_load_credentials()
{
  rsudo_deploy_result=$(command -- menu \
    -H 'Deployment — load encrypted credential file' \
    -F 'Navigate: Enter | Load file: l | Escape: back' \
    -K l -d "$rsudo_deploy_browse_dir")
  rsudo_deploy_status=$?
  case $rsudo_deploy_status in
    0) ;;
    1) return 1 ;;
    *) return "$rsudo_deploy_status" ;;
  esac

  eval "set -- $rsudo_deploy_result" || return 2
  [ "$#" -eq 2 ] && [ "$1" = l ] || return 2
  [ -f "$2" ] && [ -r "$2" ] || return 2

  rsudo_deploy_browse_dir=$(command -p dirname "$2") || return 2
  # m-core owns authenticated decryption and evaluation; no new secret format.
  encoded_file_eval "$2" || return 2
  return 0
}

rsudo_deploy_menu()
(
  set +x
  rsudo_deploy_browse_dir=$(command -p pwd -P) || exit 2
  rsudo_deploy_message='Use existing rsudo credentials for remote operations.'
  rsudo_deploy_selected_group=

  while :
  do
    rsudo_deploy_result=$(command -- menu \
      -H 'rsudo deployment' \
      -F 'Enter: select | Escape: return' \
      -B "$rsudo_deploy_message" \
      -- \
      'groups@:=Select loaded credential group' \
      'load@:=Load encrypted credentials' \
      'help@:=CLI usage')
    rsudo_deploy_status=$?
    case $rsudo_deploy_status in
      0) ;;
      1) exit 0 ;;
      *) exit "$rsudo_deploy_status" ;;
    esac

    eval "set -- $rsudo_deploy_result" || exit 2
    [ "$#" -eq 2 ] && [ "$1" = enter ] || exit 2

    case $2 in
      groups)
        _rsudo_deploy_choose_group
        rsudo_deploy_status=$?
        case $rsudo_deploy_status in
          0) rsudo_deploy_message="Selected group: $rsudo_deploy_selected_group" ;;
          1) : ;;
          3) rsudo_deploy_message='No credential groups loaded.' ;;
          *) rsudo_deploy_message="Group selection failed (status $rsudo_deploy_status)." ;;
        esac
        ;;
      load)
        _rsudo_deploy_load_credentials
        rsudo_deploy_status=$?
        case $rsudo_deploy_status in
          0) rsudo_deploy_message='Credential file loaded into this menu session.' ;;
          1) : ;;
          *) rsudo_deploy_message='Credential file was not loaded.' ;;
        esac
        ;;
      help)
        rsudo_deploy_message='CLI: rsudo --load FILE:GROUP deploy help'
        ;;
      *) exit 2 ;;
    esac
  done
)
