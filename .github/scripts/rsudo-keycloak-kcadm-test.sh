#!/bin/sh
# Local, non-network adapter contract test. Does NOT test real SSH/sudo.
set -eu
self=${0%/*}
[ "$self" != "$0" ] || self=.
. "$self/../../lib/sys/sh/rsudo/rsudo-mod-keycloak.lib.sh"

work=$(mktemp -d "${TMPDIR:-/tmp}/rsudo-kcadm-test.XXXXXXXX")
trap 'rm -rf "$work"' 0 1 2 3 15
stub="$work/kcadm with spaces"
cat > "$stub" <<'KCADM_STUB'
#!/bin/sh
printf 'COUNT:%s\n' "$#"
for arg
do
  printf 'ARG:'
  printf '%s' "$arg" | od -An -tx1 | tr -d ' \n'
  printf '\n'
done
printf 'PASSWORD_SET:%s\n' "${KC_CLI_PASSWORD+x}"
printf 'PASSWORD:'
printf '%s' "${KC_CLI_PASSWORD-}" | od -An -tx1 | tr -d ' \n'
printf '\n'
case ${1-} in
  failure) printf 'kcadm-stub-error\n' >&2; exit 42 ;;
esac
KCADM_STUB
chmod +x "$stub"

# Simulate the remote rsudo stdin endpoint without inheriting the password.
rsudo()
(
  [ "$#" -eq 0 ] || exit 99
  [ "${RSUDO_INTERACTIVE-}" = false ] || exit 98
  unset KC_CLI_PASSWORD
  /bin/sh -s
)

RSUDO_KEYCLOAK_PATH=$stub
KC_CLI_PASSWORD='a'"'"'b $(not-executed)
final

'
expected=$(printf '%s' "$KC_CLI_PASSWORD" | od -An -tx1 | tr -d ' \n')
injection='$(touch "'"$work"'/injection")'
result=$(rsudo_mod_keycloak_kcadm '' 'word with spaces' "$injection" 'line
break')
printf '%s\n' "$result" | grep -qx 'COUNT:4'
printf '%s\n' "$result" | grep -qx 'PASSWORD_SET:x'
printf '%s\n' "$result" | grep -qx "PASSWORD:$expected"
[ ! -e "$work/injection" ]

unset KC_CLI_PASSWORD
result=$(rsudo_mod_keycloak_kcadm help)
printf '%s\n' "$result" | grep -qx 'PASSWORD_SET:'

set +e
(RSUDO_KEYCLOAK_PATH=; rsudo_mod_keycloak_kcadm) >/dev/null 2>&1
local_rc=$?
(RSUDO_KEYCLOAK_PATH=relative/path; rsudo_mod_keycloak_kcadm) >/dev/null 2>&1
relative_rc=$?
(RSUDO_KEYCLOAK_PATH=/nonexistent/remote/kcadm.sh; rsudo_mod_keycloak_kcadm) >/dev/null 2>&1
missing_rc=$?
rsudo_mod_keycloak_kcadm failure >"$work/stdout" 2>"$work/stderr"
fail_rc=$?
set -e
[ "$local_rc" -eq 64 ]
[ "$relative_rc" -eq 64 ]
[ "$missing_rc" -eq 127 ]
[ "$fail_rc" -eq 42 ]
grep -qx 'kcadm-stub-error' "$work/stderr"
printf '%s\n' 'rsudo keycloak local adapter tests: PASS'
