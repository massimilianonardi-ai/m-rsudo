# rsudo-deploy — documentation index

**Product:** `m-rsudo`. **Revision type:** specification update approved by operator, 2026-11-24. **Existing code baseline:** `05d1b08791a3f85c47b619a2f1169edbe5953332`. **Status:** entrypoint-only implementation exists; comprehensive deployment is not implemented.

This directory documents an **orchestrator** that uses the established `rsudo` model for remote work and local libraries for local work. Current executable still forwards every CLI argument to `rsudo deploy`; the approved updated CLI contract is **not implemented yet**.

| Topic | Document |
| --- | --- |
| Goal and scope | [Objectives](objectives.md) |
| Binding requirements | [Requirements](requirements.md) |
| Operator workflows | [Use cases](use-cases.md) |
| Observable outcomes | [Acceptance](acceptance.md) |
| System boundaries | [Architecture](architecture.md), [Components](components.md) |
| CLI/API | [Interfaces](interfaces.md) |
| First infrastructure scenario | [Initial scope](initial-scenario.md), [SCN-01 functional specification](scenario-01-functional.md), [dependencies](scenario-01-dependencies.md), [acceptance](scenario-01-acceptance.md), [open decisions](scenario-01-decisions.md) |
| Desired project and observed state | [Plan model](plan-model.md) |
| Preparation/execution lifecycle | [Deployment lifecycle](deployment-lifecycle.md) |
| Audit and evidence | [Logging and evidence](logging-evidence.md) |
| Protected dependencies and task boundaries | [Component protection](component-protection.md) |
| Decision history | [Decisions](decisions.md) |
| Verification | [Tests](tests.md), [Supervision](supervision.md) |
| Sequencing | [Execution plan](execution-plan.md) |

Authority labels: **approved** = explicit operator decision; **proposed** = design recommendation awaiting review; **implemented** = present in repository; **verified** = linked actual test evidence. Do not infer one from another.

Credential decryption, unattended access and transport remain exclusively owned by rsudo/m-core. No redesign or retest of those established subsystems is in scope.
