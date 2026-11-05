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
printf '%s\n' 'PASS: real installed v0.1.1 public package views and libraries'
