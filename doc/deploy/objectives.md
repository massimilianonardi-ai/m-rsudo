# Objectives — deploy (L1)

**Status:** approved direction; detailed resource scope still being formalized.

Provide an administrative tool for the user's application and web infrastructure, reusing existing rsudo modules and remote access model. Support human-guided changes and unattended execution without embedding remote passwords/secrets in deployment configuration.

The operator wants one cohesive product in `m-rsudo`: native `rsudo deploy` CLI, an independent `rsudo-deploy` menu executable, and a small menu hook from `rsudo-admin`.

**Not in scope for the initial slice:** actual deployment mutation, database reset, product configuration changes, live server access, altering rsudo credential semantics, a new plugin system, a second repository.

Future resource coverage includes deployed services, packages, applications, Keycloak, APISIX, PostgreSQL, GeoServer, web servers and related infrastructure, subject to separate documented contracts.
