# SCN-01 — operator decision review

**Status:** proposed alternatives for review, not approved. Earlier confirmed product/module restrictions remain binding.

## SCN-D01 — actual network and hosting topology

Proposed first scenario: APISIX is the public gateway, nginx serves content behind it, Keycloak is an existing identity provider. Need confirm whether instances are already linked, whether app URLs use hostnames, path prefixes or both, whether nginx origins are already inaccessible directly to external users, and whether DNS/TLS are pre-existing prerequisites. Do not design an installation or assume particular server layout. Recommend existing DNS/TLS and explicit desired full URL per exposure for first scope; support multiple instances via explicit references.

## SCN-D02 — authentication and authorization semantics

Proposed: access is enforced before protected HTML/JS/CSS are delivered, not by client-side JS. Keycloak defines identities and entitlement, with actual enforcement selected after checking current integration. Need decide whether existing realm(s), clients, groups/roles are merely referenced, or deployment may create/manage those objects; whether user lifecycle/membership is part of deployment or administered separately. Recommend existing realm and users, declare desired access policy per app and explicitly scoped app-related identity resources; no automatic identity deletion. Exact OIDC, plugin or authorization mechanism is not a design assumption.

## SCN-D03 — content ownership and hosting

Proposed: first support an explicitly chosen local directory of ready-to-publish static files (or artifact reference if that better reflects actual use), map to a defined managed nginx hosting location. No build pipeline, source-code checkout or general package installation assumed. Need choose whether an app already exists remotely and is reference-only, whether deploy copies/updates the content, or both. For owned content verify fingerprint, path permissions and update scope; do not overwrite shared directories.

## SCN-D04 — ownership of existing remote resources

Proposed: default to explicit managed set, reference existing shared objects without changing them, require deliberate adoption of existing objects before taking ownership, and explicit removal authorization. Absence from project is not blanket permission to delete. Need confirm whether this matches operational model or whether the operator intends the project to be authoritative for a whole instance. Default safe scope does not settle future delete/unpublish semantics or rollback policy.

These four decisions shape functional acceptance and data model. Other engineering details can be derived independently after evidence gathering: exact schema/CLI, operation interfaces, freshness checks, log storage, retry/partial recovery. No remote access or existing product modifications authorized by this review.
