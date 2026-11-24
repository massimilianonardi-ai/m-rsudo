#!/bin/sh
# Tests only NEW deployment entrypoint wiring with synthetic local state.
# Does not test rsudo SSH, sudo or the established credential implementation.
set -eu

test_dir=$(CDPATH= cd -P "$(dirname "$0")" && command -p pwd -P) || exit 2
root=$(CDPATH= cd -P "$test_dir/.." && command -p pwd -P) || exit 2
work=$(command -p mktemp -d "${TMPDIR:-/tmp}/rsudo-deploy-test.XXXXXX") || exit 2
trap 'command -p rm -rf "$work"' 0 HUP INT TERM

for f in \
  "$root/bin/sys/rsudo-deploy" \
  "$root/bin/sys/rsudo-admin" \
  "$root/lib/sys/sh/rsudo/rsudo-deploy.lib.sh" \
  "$root/lib/sys/sh/rsudo/rsudo-mod-deploy.lib.sh" \
  "$root/build.sh"
do
  sh -n "$f" || exit 3
done

# A sourced menu library defines functions and does not start the menu.
sh -c '. "$1"; command -v rsudo_deploy_menu >/dev/null' sh \
  "$root/lib/sys/sh/rsudo/rsudo-deploy.lib.sh" || exit 4

package_lib="$work/pkg/m-rsudo@vtest/link/lib/sh"
command -p mkdir -p "$package_lib" "$work/bin" "$work/core/sys/sh" || exit 5
command -p cp "$root/lib/sys/sh/rsudo/rsudo-deploy.lib.sh" "$package_lib/" || exit 5

# Installed m-core and rsudo APIs are simulated here only to test scope wiring.
cat > "$work/core/sys/sh/core.lib.sh" <<'MOCK_CORE'
valid_shell_identifier()
{
  case $1 in '' | [0-9]* | *[!a-zA-Z0-9_]*) return 1 ;; esac
  return 0
}
MOCK_CORE

cat > "$package_lib/rsudo.lib.sh" <<'MOCK_RSUDO_LIBRARY'
# Deliberately not exported: rsudo-admin sourced-library boundary.
RSUDO_CREDENTIALS_GROUP_TEST_HOST=example.invalid
MOCK_RSUDO_LIBRARY

cat > "$work/bin/rsudo" <<'MOCK_RSUDO'
#!/bin/sh
printf '%s\n' "$@" > "$RSUDO_TEST_ARGS"
MOCK_RSUDO

cat > "$work/bin/menu" <<'MOCK_MENU'
#!/bin/sh
n=$(command -p cat "$RSUDO_TEST_MENU_COUNT" 2>/dev/null) || n=0
n=$((n+1))
printf '%s\n' "$n" > "$RSUDO_TEST_MENU_COUNT"
case "${RSUDO_TEST_MODE:-}:$n" in
  standalone:1) exit 1 ;;
  admin:1) printf 'enter deploy\n' ;;
  admin:2) printf 'enter groups\n' ;;
  admin:3)
    case "$*" in
      *'Credential group: TEST'*) printf 'enter TEST\n' ;;
      *) exit 2 ;;
    esac
    ;;
  admin:4|admin:5) exit 1 ;;
  *) exit 2 ;;
esac
MOCK_MENU
command -p chmod +x "$work/bin/rsudo" "$work/bin/menu" || exit 5
command -p cp "$root/bin/sys/rsudo-deploy" "$work/bin/rsudo-deploy" || exit 5

# Preserve the exact original argument vector when calling the native CLI.
RSUDO_TEST_ARGS="$work/rsudo-args"
export RSUDO_TEST_ARGS
m_ROOT=/mock m_LIB_DIR="$work/core" \
  PATH="$work/bin:$package_lib:$PATH" \
  sh "$root/bin/sys/rsudo-deploy" 'with spaces' '' 'x=y' || exit 6
printf '%s\n' deploy 'with spaces' '' 'x=y' |
  command -p cmp - "$RSUDO_TEST_ARGS" || exit 7

# Standalone no-arguments path sources the library, then cleanly exits.
RSUDO_TEST_MENU_COUNT="$work/menu-count" RSUDO_TEST_MODE=standalone
export RSUDO_TEST_MENU_COUNT RSUDO_TEST_MODE
printf '0\n' > "$RSUDO_TEST_MENU_COUNT"
m_ROOT=/mock m_LIB_DIR="$work/core" \
  PATH="$work/bin:$package_lib:$PATH" \
  sh "$root/bin/sys/rsudo-deploy" || exit 8
[ "$(command -p cat "$RSUDO_TEST_MENU_COUNT")" = 1 ] || exit 9

# Admin-sourced integration must pass a NON-exported synthetic credential group
# into the nested menu and return to admin without invoking a remote rsudo.
RSUDO_TEST_MODE=admin
export RSUDO_TEST_MODE
printf '0\n' > "$RSUDO_TEST_MENU_COUNT"
m_ROOT=/mock m_LIB_DIR="$work/core" m_PKG_DIR="$work/pkg" \
  PATH="$work/bin:$package_lib:$PATH" \
  sh "$root/bin/sys/rsudo-admin" || exit 10
[ "$(command -p cat "$RSUDO_TEST_MENU_COUNT")" = 5 ] || exit 11

# Build only a fresh temporary archive, never modify an immutable release.
sh "$root/build.sh" "$work/build" || exit 12
[ -f "$work/build/root/bin/rsudo-deploy" ] || exit 13
[ -f "$work/build/root/lib/sh/rsudo-deploy.lib.sh" ] || exit 14
[ -f "$work/build/root/lib/sh/rsudo-mod-deploy.lib.sh" ] || exit 15

printf '%s\n' 'PASS: deploy source, wrapper, menu scope, admin hook, packaging'
