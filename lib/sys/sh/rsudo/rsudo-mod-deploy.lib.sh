# rsudo deploy — native deployment CLI adapter.
# The rsudo dispatcher, not this module, owns authentication and transport.

rsudo_mod_deploy_help()
{
  [ "$#" -eq 0 ] || return 2
  printf '%s\n' \
    'Usage: rsudo [rsudo-options] deploy help' \
    'Interactive menu: rsudo-deploy (or Deploy from rsudo-admin).' \
    'This is the initial interface integration; resource operations are not yet implemented.'
}
