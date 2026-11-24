# SCN-01 — deploy a protected static web application

**Status:** L2–L3 refined with approved D01–D08; actual configuration discovery pending (2026-11-24). Approved parent scope: [objectives](objectives.md), [requirements](requirements.md), [initial scenario](initial-scenario.md). Existing products are not reconfigured or installed by this specification.

## Functional result

A project describes one or more HTML/JS/CSS applications. A selected application can be hosted through an existing nginx instance, exposed at its desired URL via an existing APISIX instance, and accessed only under the required Keycloak-backed identity and authorization policy. Treat application as a logical aggregation, not necessarily as the exclusive owner of all involved resources. Existing instances and shared resources can be referenced.

Operator-described topology: browser -> HTTPS cloaker/iframe -> public APISIX entry -> nginx origin; separate publicly reachable Keycloak authenticates against Active Directory and holds the existing APISIX client authorization configuration. All public URLs use HTTPS, HTTP redirects. Only APISIX reaches separate application origins; colocated nginx binds loopback. This is reported architecture, not live verification. Exact enforcement mechanism remains to be inspected. APISIX entrance is an application menu; protected direct APISIX paths are valid, ordinary applications have no direct origin exposure. Cloaker is deployment-managed, exact host unknown. APISIX-to-nginx currently HTTP; public endpoints use HTTPS. AD and local Keycloak identities/groups coexist. See [D01–D08](scenario-01-decisions.md).

## Logical information model (not a schema)

| Concept | Meaning |
| --- | --- |
| Project | Revisable desired configuration, independent of observations |
| Server | Administration target referenced through existing rsudo credential groups |
| Instance | Existing APISIX, Keycloak or nginx installation on a server |
| Application | Logical app identity and its references to related resources |
| Content | Desired static files and version/fingerprint |
| Hosting | Intended nginx location/configuration for content |
| Exposure | Intended public URL and APISIX routing |
| Identity | Referenced or managed realm/client/user/group/role resources, according to approved ownership |
| Access policy | Desired authorization behavior, independent of product-specific encoding |

These concepts need not map one-to-one to files, modules or schema kinds. Determine concrete model after scenario decisions. One app can share instances, identity resources and hosting infrastructure with others.

## Functional operations

| Operation | Input | Result | Effects |
| --- | --- | --- | --- |
| Configure | Project + changes | New desired state | Local only |
| Validate | Project and selection | Errors/warnings with resource references | Local only |
| Observe | Selected instances/resources | Actual state or explicit unknown | Remote read only |
| Compare | Desired revision + observations | Differences, conflicts and unknowns | Local only |
| Prepare | Selection, differences, observations | Dependency-ordered candidate action plan, blockers, risk and evidence requirements | Local + remote read only |
| Apply | Reviewed/authorized prepared plan | Attempted actions and durable execution record | Authorized remote changes only |
| Verify | Desired scope and execution record | Configuration/content/access observations | Remote/public read checks, controlled test authentication |
| Report | Evidence + residual differences | Verified/partial/failed/inconclusive outcome and operator decisions needed | Local only |

The operations are semantics, not proposed CLI verbs. Local operations must not require rsudo; remote work uses existing rsudo credential semantics. See [component protection](component-protection.md).

## Representative lifecycle (proposed)

1. Create a project and reference the required existing instances; define one app, its content, exposure and policy.
2. Validate local references and content. Observe managed resources and relevant shared resources; establish access and capability prerequisites.
3. Before ordinary deployment, acquire existing managed configurations read-only and review the initial project. Compare approved desired state against observations, including explicit operational association exceptions; identify blockers and prepare only necessary selected changes. No automatic deletion or reconciliation.
4. Review scope and dependencies, authorize changes. Stage content and required identity/access configuration before making a new public exposure active; for existing routes use a separately justified safe transition, never assume atomicity.
5. Apply with per-action precondition and result evidence. A failed dependency blocks affected steps; ambiguous effects require readback and human review, not blind retry.
6. Independently verify configuration, exact expected content and effective access rules at all relevant paths. Report residual drift; do not auto-correct.

## Boundary of this iteration

No final JSON layout, OIDC/plugin choice, realm model, nginx layout, route naming, deployment transaction or CLI grammar. D01–D08 are answered in [scenario decisions](scenario-01-decisions.md). See [resource model](resource-model.md) and [initial acquisition](initial-acquisition.md) for proposed architecture work; actual read-only discovery and review remain before dependent implementation. [Acceptance](scenario-01-acceptance.md) defines candidate observable outcomes and [dependency contracts](scenario-01-dependencies.md) records actual inspected capabilities.
