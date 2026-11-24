# SCN-01 — decisions and remaining boundaries

**Authority:** explicit operator clarification, 2026-11-24, conversation checkpoint 13. D01–D04 materially answered; remaining questions below are narrower. No runtime verification or authorization to modify servers.

## SCN-D01 — network and hosting (approved)
- One intended user entry point: minimal HTML URL cloaker containing an iframe pointing to an APISIX entrance URL.
- HTTP redirects to HTTPS; URLs are HTTPS. APISIX and Keycloak are distinct publicly reachable servers, currently not behind a reverse proxy. Keep current topology for initial scope. A different reverse proxy architecture is future investigation, not prerequisite.
- Other apps are reachable only via APISIX. For a separate nginx origin, application connections must be allowed only from APISIX; for colocated nginx, bind to 127.0.0.1. nginx currently separate. DNS is a prerequisite already satisfied. TLS certificates belong to deployment scope, possibly deferred in initial slice.
- Cloaker is presentation, not authorization. Direct requests to protected APISIX URLs must still be protected.

## SCN-D02 — identity and access (approved)
Existing dedicated Keycloak realm authenticates via Active Directory. Existing APISIX client has path/resource-specific permissions and roles associated with some APISIX routes. Deployment exclusively manages roles, paths and permissions. Deployment must support user/group/role associations, while routine association administration uses Keycloak Webadmin. Preserve existing identity/auth integration. No replacement plugin or authorization mechanism chosen.

## SCN-D03 — content (approved)
Ready-to-copy static files, no build, originate in a local Git working repository pushed to a private intranet bare Git repository. Bare repository is authoritative for sources; either source may be used for acquisition. **Proposed:** bind preparation to an exact revision/content fingerprint; never silently switch revisions during a long apply.

## SCN-D04 — authority (approved)
Deployment exclusively manages infrastructure resources, notably APISIX and Keycloak; the explicit ordinary association-management exception from D02 remains. First export existing configurations. Supersedes proposed managed-subset-only default. Authority does not imply that absence authorizes deletion or automatic drift repair. Selected deployments remain supported.

## Remaining operator questions
- Q01: cloaker hosting and ownership, APISIX entry application/navigation, URL patterns (host/path or both). Is the cloaker included in initial deployment, or an existing prerequisite?
- Q02: does HTTPS-only extend to APISIX-to-nginx upstream connections, including loopback, or only browser/public URLs? Certificates needed for initial deployment versus later automated lifecycle.
- Q03: whether group definitions/AD group mappings and users are deployment-managed or existing identity infrastructure; proposed policy: only explicitly requested association changes, routine Webadmin changes preserved and not mistaken for unauthorized structural drift.
- Q04: scope of initial export and transition: proposed read-only inventory/export for all managed configurations, then normalized reviewable initial project, separate observed/runtime/derived data and protected secret references. Are global product/identity integration settings included immediately or inventoried and deferred? No implicit removal or changes during import.

These are functional scope decisions, not requests for technical implementation details. Exact versions, paths, plugins, current configuration and topology details should be discovered through a separately authorized read-only collection; no real hostnames, credentials or exports in public repositories.
