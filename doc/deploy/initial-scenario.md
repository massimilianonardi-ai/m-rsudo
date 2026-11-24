# First scenario — secure static web applications

**Approved goal:** administer existing APISIX, Keycloak and nginx to publish a set of HTML/JavaScript/CSS applications under URLs with authentication and authorization. This is the **first deployment product slice**, not a plan to install or rewrite those products.

## Target effects (functional)

1. Manage selected static app files and associated hosting configuration using existing nginx estate.
2. Make each app available at an explicit intended URL via APISIX.
3. Require authentication and authorization backed by Keycloak at the effective access boundary.
4. Verify for selected test identities that eligible access works, unauthenticated access is challenged/denied, and unauthorized access is denied.
5. Record actual routes, target endpoints, app version/content fingerprint, identity/policy binding and residual drift as evidence, subject to later detailed schemas.

## Approved scenario refinements

See [SCN-D01–D04](scenario-01-decisions.md): HTTPS cloaker/iframe entry, distinct public APISIX and Keycloak, restricted nginx origin, existing dedicated realm and AD-backed identity, existing client path/permission/role configuration, exclusive infrastructure configuration management with ordinary Webadmin association exception, authoritative bare Git source, initial export. No change to current topology is a prerequisite. Certificates remain in product scope; DNS is existing.

Exact current configuration, runtime versions, enforcement, source layout and residual operator scope decisions must be established before dependent design. Browser JavaScript and URL cloaking are not access enforcement. No actual server access or test performed.

**Dependency rule:** identified missing capabilities become separate approved tasks, not modifications to protected modules here.

See [functional specification](scenario-01-functional.md), [source dependency contracts](scenario-01-dependencies.md), [acceptance cases](scenario-01-acceptance.md) and [decisions](scenario-01-decisions.md).
