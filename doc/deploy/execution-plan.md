# Incremental execution plan (L8)

| Step | Deliverable | Done evidence | Status |
| --- | --- | --- | --- |
| STEP-01 | Approved integration architecture and scoped docs | Operator agreement + product docs | Done |
| STEP-02 | Source-only menu library, native `deploy` module entry, standalone executable, one admin menu hook | Product source and package recipe | Initial implementation |
| STEP-03 | Integration-only local syntax/menu/wrapper/package checks | Test outputs with actual files | Pending |
| STEP-04 | Specify directory-based JSON resources, identity, validation and state semantics | L1-L7 extended resource contracts | Pending |
| STEP-05 | Implement one safe read-only end-to-end deployment view through rsudo | Actual output and focused tests | Pending |
| STEP-06 | Add planned changes, user-approved safety controls, apply/verify and product-specific adapters | Repeatable tests and documented risks | Pending |
| STEP-07 | Installation/release and operational acceptance on authorized infrastructure | Verified package and real environment | Pending |

No production server operations or release publication are authorized by STEP-01/02. `m-rsudo/v0.1.3` released artifacts remain immutable; changes on source main are unreleased. Update release versioning and catalog only as a separate release milestone.
