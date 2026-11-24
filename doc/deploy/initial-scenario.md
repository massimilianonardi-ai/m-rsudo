# First scenario — secure static web applications

**Approved goal:** administer existing APISIX, Keycloak and nginx to publish a set of HTML/JavaScript/CSS applications under URLs with authentication and authorization. This is the **first deployment product slice**, not a plan to install or rewrite those products.

## Target effects (functional)

1. Manage selected static app files and associated hosting configuration using existing nginx estate.
2. Make each app available at an explicit intended URL via APISIX.
3. Require authentication and authorization backed by Keycloak at the effective access boundary.
4. Verify for selected test identities that eligible access works, unauthenticated access is challenged/denied, and unauthorized access is denied.
5. Record actual routes, target endpoints, app version/content fingerprint, identity/policy binding and residual drift as evidence, subject to later detailed schemas.

## Non-assumptions / decisions required before implementation

- Actual traffic path and whether nginx hosts static files behind APISIX, direct externally accessible nginx routes, or other arrangement.
- Which component **enforces** authorization (APISIX gateway, nginx, application endpoint, or combinations) and how Keycloak clients, roles, scopes and tokens map to apps.
- Ownership of existing Keycloak realm/client/role objects and APISIX routes/upstreams; ability to observe/update them via current modules, without changing those modules.
- The source and lifecycle of static files, URL/DNS/TLS endpoints, target server naming and access boundaries; no hostnames/secrets are published here.
- In-place updates, maintenance windows, activation/rollback expectations, and which changes count as destructive.

**Security constraint:** Browser JavaScript cannot enforce server-side access controls or hold service credentials securely. If the public requirement is that the *static assets themselves* are access controlled, the public request path must enforce it before delivering those assets. This is an acceptance criterion, not an assumed plugin choice.

**Dependency rule:** if the current apisix/keycloak/keysix/other tools cannot satisfy an identified contract, raise a separate task and wait for its result before using that capability.
