# Deployment subsystem — index (initial integration slice)

**Repository:** `m-rsudo`. **Status:** integration slice implemented; deployment resource management **not implemented**.
**Baseline evidence:** `m-rsudo@fad7b8b49ea9b966e56013f1a66736587633ba65`.

The operator approved retaining the established rsudo credential architecture and using: native CLI `rsudo deploy`, a source-only menu library, a standalone `rsudo-deploy` entrypoint, and a single `Deploy` entry in `rsudo-admin`.

## Documents

- [Objectives](objectives.md) — what deployment administration must achieve.
- [Requirements](requirements.md) — preserved contracts and requested capabilities.
- [Use cases](use-cases.md) — representative operator flows.
- [Acceptance](acceptance.md) — acceptance and observed evidence.
- [Architecture](architecture.md) — component boundaries and execution paths.
- [Interfaces](interfaces.md) — public and internal function contracts.
- [Decisions](decisions.md) — approved choices and deferred questions.
- [Tests](tests.md) — new integration checks only.
- [Execution plan](execution-plan.md) — incremental completion path.
- [Supervision](supervision.md) — checked milestone evidence.

**Important:** rsudo authentication, decryption and unattended credential management are already-established product capabilities. This project does not redesign or re-validate those internals. New test scope is integration of deployment entrypoints and their expected shell scope.
