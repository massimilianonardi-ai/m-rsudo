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
# Execute only in-memory bytes from the selected, installed release views.
loadlib_inject_stream base \
  --library array "$core_lib/array.lib.sh" \
  --library map "$core_lib/map.lib.sh" \
  --library term "$term_lib/term.lib.sh" \
  --library menu "$term_lib/menu.lib.sh" \
  --library menu-command "$term_lib/menu-command.lib.sh" <<'EOF_REMOTE' | env -i PATH=/usr/bin:/bin sh
[ -z "${m_ROOT-}" ] || exit 20
command -v menu_command_main >/dev/null || exit 21
(menu_command_main -Z) >/dev/null 2>&1
[ "$?" -eq 2 ] || exit 22
EOF_REMOTE

printf '%s\n' 'PASS: public v0.1.1 installation, native commands and selected rssh shell extension'
