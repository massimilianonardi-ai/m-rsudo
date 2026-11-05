#!/bin/sh
# Package the real project-owned POSIX sources without embedding m-os.
set -eu
[ "$#" -eq 1 ] || { printf 'usage: sh build.sh <new-output-directory>\n' >&2; exit 2; }
output_root=$1
[ ! -e "$output_root" ] && [ ! -L "$output_root" ] || exit 3
self_dir=${0%/*}
[ "$self_dir" != "$0" ] || self_dir=.
command -p -- mkdir -p -- "$output_root/root/bin" "$output_root/root/lib/sh" "$output_root/root/res/manual"
for name in rsudo rsudo-mod-exec rsudo-mod-fs rsudo-mod-db-pg rsudo-mod-apisix rsudo-mod-apisixlegacy rsudo-mod-keycloak rsudo-mod-keycloaklegacy
do
  source_file="$self_dir/lib/sys/sh/rsudo/$name.lib.sh"
  [ -f "$source_file" ] && [ -r "$source_file" ] || exit 4
  command -p -- sh -n "$source_file" || exit 5
  command -p -- cp -- "$source_file" "$output_root/root/lib/sh/$name.lib.sh"
  command -p -- chmod 644 "$output_root/root/lib/sh/$name.lib.sh"
done
for name in rsudo rsudo-admin rssh
do
  source_file="$self_dir/bin/sys/$name"
  [ -f "$source_file" ] && [ -r "$source_file" ] || exit 6
  command -p -- sh -n "$source_file" || exit 7
  command -p -- cp -- "$source_file" "$output_root/root/bin/$name"
  command -p -- chmod 755 "$output_root/root/bin/$name"
done
for source_file in "$self_dir"/res/sys/manual/*
do
  [ -f "$source_file" ] || continue
  command -p -- cp -- "$source_file" "$output_root/root/res/manual/${source_file##*/}"
done
command -p -- mkdir -p -- "$output_root/root/res/testlab/scenarios"
command -p -- cp -- "$self_dir/res/sys/testlab/scenarios/rsudo" "$output_root/root/res/testlab/scenarios/rsudo"
(
  CDPATH= cd -- "$output_root/root"
  command -p -- tar -czf "../m-rsudo-v0.1.0-all.tar.gz" bin lib res
)
