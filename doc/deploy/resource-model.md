# Conceptual resource model (L4 proposal)

**Inputs:** approved REQ-08–24, D01–D08; source dependency audit in scenario-01-dependencies.md. No final JSON schema, code change or live inventory.

## Functional areas

| Area | Candidate resource concepts | Purpose |
| --- | --- | --- |
| Infrastructure | Server, product instance, network endpoint, DNS reference | Explicit target and topology; DNS is existing prerequisite |
| Security | Certificate, access restriction, secret reference | Public TLS, origin isolation, protected access; secrets outside project |
| Identity | Realm, federation, client, identity/group reference | Preserve existing identity model and local/federated provenance |
| Authorization | Role, protected resource/path, policy, permission, assignment | Structural authorization managed by deployment; operational memberships nonexclusive |
| Hosting | nginx configuration, hosting location, content reference | Serve exact selected static artifacts |
| Gateway | APISIX global settings, route, upstream, plugin/config reference | Public path routing and server-side access enforcement |
| Applications | Cloaker, menu, ordinary app, source revision and resource relationships | User-facing logical unit; special roles do not imply separate engines |

These areas classify concerns, not mandatory files, libraries or native resource kinds. Logical app references existing resources instead of duplicating their definitions. Model native resources only where necessary for faithful export and apply; do not assume a one-to-one relation between an app, route, role, permission or upstream. Shared and global resources can be dependencies of many apps.

## Proposed management classes (per resource or field)

| Class | Desired/observed semantics |
| --- | --- |
| Exclusive structural | Project owns configuration; unauthorized deviation is drift; remediation manual. Examples: APISIX routes, roles, protected paths and permissions. |
| Shared operational | Observed and can be changed on explicit request; preserve changes through authorized ordinary administration. Examples: groups and user/group/role associations. |
| Reference / prerequisite | Referenced and checked; no implied mutation authority. Examples: external AD identities, DNS prerequisites. |
| Observed/derived | Capture for evidence; not a desired configuration field. Examples: process state, timestamps, generated identifiers. |

Users may be local or federated; actual scope of local user lifecycle actions remains unspecified. Do not interpret reference-only identity as authority to modify AD. Treat role definitions and role assignments separately. Exclusive authority does not mean absence authorizes delete. Unobservable is unknown, never absent.

## Relationships and planning

- Server hosts product instance; app references source content and hosting/exposure/policy.
- Hosting points to nginx location; APISIX route references target upstream and required access configuration; Keycloak policy refers to defined roles/resources/permissions and identity references.
- Source identity and revision must be resolved at preparation (proposed exact content binding).
- Dependencies distinguish validation-only references from required state changes. Selecting one application may require shared resources: report closure, risks and proposed extra actions explicitly; never silently widen authorization.
- Stable project IDs should be distinct from product-specific IDs where needed; namespace native identities by instance and identity source, preserve mapping through import. Names alone may be ambiguous.

## Data layers

Desired project, raw acquisition/observations, normalized comparison, prepared actions, execution evidence are separate records. Do not auto-adopt drift, replay exports or store credentials in project files. Exact identifiers, resource field representation, file grouping and schema versioning follow inspection of real configuration and approval.

See [initial acquisition](initial-acquisition.md), [lifecycle](deployment-lifecycle.md) and [requirements](requirements.md).
