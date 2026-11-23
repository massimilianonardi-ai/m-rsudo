# Keysix: administration of linked APISIX and Keycloak instances.
# Initial module: description only; no operational commands yet.

rsudo_mod_keysix_help()
{
  printf '%s\n' \
    'rsudo keysix' \
    'Amministra istanze collegate di APISIX e Keycloak per la gestione' \
    'di servizi web protetti da autenticazione e autorizzazioni basate' \
    'sui ruoli (RBAC).'
}
