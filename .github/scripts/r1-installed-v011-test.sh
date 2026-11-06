#!/bin/sh
set -eu
[ -n "${m_ROOT:-}" ] && [ -n "${m_PKG_DIR:-}" ] || exit 1
. "$m_LIB_DIR/sys/sh/core.lib.sh" || exit 2
context pkg=m-core@v0.1.1 pkg=m-term@v0.1.1 pkg=m-rsudo@v0.1.1 || exit 3
core_lib="$m_PKG_DIR/m-core@v0.1.1/link/lib/sh"
term_lib="$m_PKG_DIR/m-term@v0.1.1/link/lib/sh"
rsudo_lib="$m_PKG_DIR/m-rsudo@v0.1.1/link/lib/sh"
[ "$(command -v menu)" = "$m_PKG_DIR/m-term@v0.1.1/link/bin/menu" ] || exit 4
[ "$(command -v rssh)" = "$m_PKG_DIR/m-rsudo@v0.1.1/link/bin/rssh" ] || exit 5
[ "$(command -v rsudo-admin)" = "$m_PKG_DIR/m-rsudo@v0.1.1/link/bin/rsudo-admin" ] || exit 6
for path in "$core_lib/array.lib.sh" "$core_lib/map.lib.sh" "$core_lib/loadlib-inject-stream.lib.sh" "$term_lib/term.lib.sh" "$term_lib/menu.lib.sh" "$term_lib/menu-command.lib.sh" "$rsudo_lib/rsudo.lib.sh"
do
  [ -L "$path" ] && [ -r "$path" ] || exit 7
done
. array.lib.sh
. map.lib.sh
. term.lib.sh
. menu.lib.sh
. menu-command.lib.sh
. loadlib-inject-stream.lib.sh
. rsudo.lib.sh
command -v menu_command_main >/dev/null || exit 8
# Run the shipped native menu/admin error paths before any terminal session.
menu_status=0
menu -Z >/dev/null 2>&1 || menu_status=$?
[ "$menu_status" -eq 2 ] || exit 9
admin_status=0
rsudo-admin --invalid >/dev/null 2>&1 || admin_status=$?
[ "$admin_status" -eq 1 ] || exit 10

# The real rssh command must pass the selected package extension to m shell.
rssh_shell_extension=$(SHELL=/bin/sh rssh -c 'printf "%s" "$m_SHELL_EXT"')
[ "$rssh_shell_extension" = "$rsudo_lib/rsudo.lib.sh" ] || exit 11
# Check actual published command failures, without replacing any package.
rssh_bin="$m_PKG_DIR/m-rsudo@v0.1.1/link/bin/rssh"
admin_bin="$m_PKG_DIR/m-rsudo@v0.1.1/link/bin/rsudo-admin"
work_dir=$(mktemp -d) || exit 12
trap 'rm -f "$work_dir/"*; rmdir "$work_dir"' 0

r1_expect_status()
{
  expected=$1
  shift
  status=0
  "$@" > "$work_dir/status.out" 2>&1 || status=$?
  if [ "$status" -ne "$expected" ]
  then
    printf 'Expected status %s, received %s\n' "$expected" "$status" >&2
    cat "$work_dir/status.out" >&2
    return 1
  fi
}

r1_expect_status 1 env m_ROOT= "$rssh_bin" -c : || exit 13
r1_expect_status 3 env m_PKG_DIR= "$rssh_bin" -c : || exit 14
r1_expect_status 4 env PATH=/usr/bin:/bin "$rssh_bin" -c : || exit 15
r1_expect_status 3 env PATH=/usr/bin:/bin "$admin_bin" || exit 16

# A repeated reference to the same genuine selected concrete is permitted.
rssh_duplicate=$(PATH="$rsudo_lib:$rsudo_lib:$PATH" SHELL=/bin/sh "$rssh_bin" -c 'printf "%s" "$m_SHELL_EXT"') || exit 17
[ "$rssh_duplicate" = "$rsudo_lib/rsudo.lib.sh" ] || exit 18

# The injection generator must fail before emitting any source for a missing
# caller-selected library. It must also finish successfully before execution.
generator_status=0
loadlib_inject_stream --library missing "$work_dir/not-a-library" > "$work_dir/invalid.sh" || generator_status=$?
[ "$generator_status" -eq 2 ] && [ ! -s "$work_dir/invalid.sh" ] || exit 19

loadlib_inject_stream base \
  --library array "$core_lib/array.lib.sh" \
  --library map "$core_lib/map.lib.sh" \
  --library term "$term_lib/term.lib.sh" \
  --library menu "$term_lib/menu.lib.sh" \
  --library menu-command "$term_lib/menu-command.lib.sh" > "$work_dir/injected.sh" <<'EOF_REMOTE'
[ -z "${m_ROOT-}" ] || exit 20
command -v menu_command_main >/dev/null || exit 21
(menu_command_main -Z) >/dev/null 2>&1
[ "$?" -eq 2 ] || exit 22
printf '%s\n' 'injected menu PASS'
EOF_REMOTE

[ -s "$work_dir/injected.sh" ] || exit 23
sh -n "$work_dir/injected.sh" || exit 24
injected_result=$(env -i PATH=/usr/bin:/bin sh "$work_dir/injected.sh") || exit 25
[ "$injected_result" = 'injected menu PASS' ] || exit 26

printf '%s\n' 'PASS: real v0.1.1 installed views, native commands, rssh negative paths and injected source'
# The only terminal interaction is with the actual installed menu and
# rsudo-admin, over a disposable PTY; no credential group or remote host.
python3 "${0%/*}/r1-pty-admin-test.py"
