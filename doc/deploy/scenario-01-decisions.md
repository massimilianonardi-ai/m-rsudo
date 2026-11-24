# SCN-01 — decisions and remaining boundaries

**Authority:** explicit operator clarification, 2026-11-24, conversation checkpoints 13–14. D01–D08 answered for the initial functional scope. No runtime verification or authorization to modify servers.

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

## SCN-D05 — entry and application addressing (approved)
The URL cloaker is deployment-managed; its purpose is presentation and avoiding incorrect bookmarks, not access enforcement. Its current hosting server is unknown and will be discovered. APISIX entrance URL serves the application menu. Direct public APISIX URLs are allowed subject to authentication and authorization. Each ordinary application is accessible only via an APISIX path. Preserve current architecture initially; evaluate alternatives later with evidence and approval. Cloaker is the explicitly public presentation exception.

## SCN-D06 — transport (approved current baseline)
Public APISIX and Keycloak use HTTPS; APISIX provides public TLS for the applications. Current APISIX-to-nginx connections use HTTP. Preserve this baseline for acquisition and initial design; do not impose internal HTTPS or change topology without approval. Public HTTPS/HTTP redirect and origin restrictions from D01 remain binding. Certificate management belongs to the eventual deployment product; timing remains incremental.

## SCN-D07 — identity administration (approved)
Users may originate in AD or locally in Keycloak. Groups may originate in AD or Keycloak. Group administration is not exclusive to deployment. D02 remains binding: roles, protected paths and permissions are managed only through deployment; deployment supports associations, ordinary association administration uses Keycloak Webadmin. Proposed safe default: represent identities/groups with origin-qualified references and modify operational associations only when explicitly requested. Do not erase legitimate ordinary changes or administer AD directly by inference.

## SCN-D08 — acquisition scope (approved)
Initial acquisition includes both infrastructure/global settings and application-specific configuration. Proposed transition: capture read-only evidence, normalize and review a candidate initial project, separate runtime/derived fields and secret references, then compare against real state before any approved changes. Acquire both levels even if write support arrives incrementally.

## Discovery facts, not new operator questions
Collect actual instance versions, topology/hosting of cloaker, effective route/path mapping, existing client/policies/plugins, nginx origin restrictions, TLS endpoints, identity provenance, supported export methods and source layout from authorized evidence. Exact configuration, secret handling and read permissions must be confirmed through separately authorized read-only acquisition. No live configuration collected yet. Detailed authority and schema, revision binding and execution semantics are engineering proposals requiring review before code changes. No public repository shall receive private infrastructure exports, user directories, tokens or secrets.
