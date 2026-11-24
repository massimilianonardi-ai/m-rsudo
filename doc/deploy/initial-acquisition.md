# Initial configuration acquisition — proposed contract

**Approved scope:** D08 requires acquiring both global/infrastructure and application settings. This document proposes read-only acquisition and reviewed transition; no execution or authorization of live access is implied.

| Domain | What to identify |
| --- | --- |
| Servers and networking | Actual rsudo target references, installed instances and versions, listeners, origin access controls, entry hosting and route topology |
| APISIX | Global/runtime configuration relevant to deployment; routes, upstreams, services, plugin configurations, relevant authorization bindings; enumerate all pages/resources in scope |
| Keycloak | Realm and federation configuration, clients, roles, protected resources/paths, policies, permissions; local/federated group and identity references and necessary association evidence. Avoid unnecessary personal records and secret values. |
| nginx | Effective configuration/includes, virtual servers, listening/hosting paths, relevant permissions and content identity |
| Public entry | Cloaker host and source, menu entry and path links, expected HTTPS endpoints and redirect behavior |
| Git source | Authoritative repository references, current revisions, content layout and deployed content correspondence |
| TLS | Relevant public certificate metadata, endpoint associations, expiry and management mechanism; never export private keys to ordinary records |

## Acquisition flow

1. Identify target and permitted scope; resolve access through existing rsudo credential contract. No product changes or privileged export action without authorization.
2. Discover installed versions/modes and choose supported read-only interfaces. Capture original configuration only as necessary in restricted local storage; keep secret-bearing exports out of public repos and logs. Record redacted evidence or references rather than raw sensitive values.
3. Enumerate applicable objects and relevant fields, record provenance, timestamps, completeness and unsupported/failed sections. A collection error is not evidence of absence.
4. Normalize into candidate project resources and identity mappings; classify exclusive structural, shared operational, reference-only and observed/derived. Preserve supported native configuration faithfully; report unsupported fields rather than silently discarding.
5. Compare candidate project with observations; report coverage, ambiguities, unknowns and discrepancies. Review candidate before establishing desired baseline.
6. After approval, the project is the desired configuration. No automatic application or deletion occurs. Later preparation/apply uses separately authorized scope and fresh evidence.

## Acceptance of acquisition (proposed)

Both configuration levels covered; every requested area either acquired or explicitly incomplete; native identity/relationship mapping traceable; no unauthorized state changes; no plaintext secrets or unnecessary personal data in ordinary output; unknowns block affected changes. Acquisition is not a restore test and does not prove full operational equivalence.

The concrete collection mechanism must follow installed capabilities. The task may design a new deploy-owned collection function or a narrowly scoped read-only rsudo job; do not alter protected modules. Missing APIs are separate tasks only after evidence. Live target access and private storage locations must be approved separately. Do not assume an export method is read-only until inspected (e.g. offline export requiring service stop is out of scope).
