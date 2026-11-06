#!/bin/sh
# Proportional R1 source-composition smoke; no SSH/sudo host access.
set -eu

[ -n "${m_ROOT:-}" ] || exit 1
[ -n "${GITHUB_WORKSPACE:-}" ] || exit 2
. "$m_LIB_DIR/sys/sh/core.lib.sh"
. "$GITHUB_WORKSPACE/core/lib/sys/sh/loadlib-inject-stream.lib.sh"

PATH="$GITHUB_WORKSPACE/core/lib/sys/sh:$GITHUB_WORKSPACE/term/lib/sys/sh:$PATH"
export PATH

for source in \
  "$GITHUB_WORKSPACE/core/lib/sys/sh/loadlib-inject-stream.lib.sh" \
  "$GITHUB_WORKSPACE/term/lib/sys/sh/menu-command.lib.sh" \
  "$GITHUB_WORKSPACE/term/lib/sys/sh/menu.lib.sh" \
  "$GITHUB_WORKSPACE/term/bin/sys/menu" \
  "$GITHUB_WORKSPACE/rsudo/bin/sys/rsudo-admin"
do
  sh -n "$source"
done

work=$(mktemp -d)
trap 'rm -rf -- "$work"' 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

# Source-only build inputs are the actual first-party source repositories.
for project in core term rsudo
do
  ( cd "$GITHUB_WORKSPACE/$project" && sh build.sh "$work/$project" )
done
[ -f "$work/term/root/lib/sh/menu-command.lib.sh" ] || exit 3
[ -f "$work/core/root/lib/sh/loadlib-inject-stream.lib.sh" ] || exit 4

# The actual native menu entrypoint rejects malformed arguments (no TTY needed).
set +e
"$GITHUB_WORKSPACE/term/bin/sys/menu" -Z > "$work/native-out" 2>&1
status=$?
set -e
[ "$status" -eq 2 ] || { cat "$work/native-out"; exit 5; }

# The actual rsudo-admin entrypoint must reject an absent selected package
# source predictably, before any interactive menu or privileged operation.
status=0
env PATH=/usr/bin:/bin "$GITHUB_WORKSPACE/rsudo/bin/sys/rsudo-admin" > "$work/admin-out" 2>&1 || status=$?
[ "$status" -eq 3 ] || { cat "$work/admin-out"; exit 9; }

# This is an in-memory program assembled from exact current source files.
loadlib_inject_stream \
  base \
  --library array "$GITHUB_WORKSPACE/core/lib/sys/sh/array.lib.sh" \
  --library map "$GITHUB_WORKSPACE/core/lib/sys/sh/map.lib.sh" \
  --library term "$GITHUB_WORKSPACE/term/lib/sys/sh/term.lib.sh" \
  --library menu "$GITHUB_WORKSPACE/term/lib/sys/sh/menu.lib.sh" \
  --library menu-command "$GITHUB_WORKSPACE/term/lib/sys/sh/menu-command.lib.sh" \
  > "$work/injected.sh" <<'EOF_SOURCE'
[ -z "${m_ROOT-}" ] || exit 21
[ -z "${m_LIB_DIR-}" ] || exit 22
command -v array >/dev/null || exit 23
command -v map >/dev/null || exit 24
command -v term_read_key >/dev/null || exit 25
command -v menu_run_provider >/dev/null || exit 26
command -v menu_command_main >/dev/null || exit 27
# The public menu function rejects a missing filesystem root before TTY use.
(menu_command_main -d /rumiai-nonexistent-r1-path) >/dev/null 2>&1
status=$?
[ "$status" -eq 2 ] || exit 28
printf '%s\n' 'R1 injected source PASS'
EOF_SOURCE

env -i PATH="/usr/bin:/bin" sh "$work/injected.sh" > "$work/result"
grep -qx 'R1 injected source PASS' "$work/result" || exit 6

# Invalid explicit input must fail before any output is emitted.
if loadlib_inject_stream --library missing "$work/absent" > "$work/invalid"
then
  exit 7
fi
[ ! -s "$work/invalid" ] || exit 8

printf '%s\n' 'PASS: native menu invalid path and source-only injected menu composition'
