# Use cases (L3)

| ID | Actor action | Observable result | State |
| --- | --- | --- | --- |
| UC-01 | Run `rsudo-deploy` from initialized m environment. | Separate deployment menu opens; Escape exits. | Initial slice |
| UC-02 | Load credentials in `rsudo-admin`, choose Deploy. | Menu inherits non-exported credential groups; closing returns to admin unchanged. | Initial slice; no live auth test |
| UC-03 | Execute `rsudo-deploy help`. | Delegates to native `rsudo deploy help`, subject to existing rsudo auth contract. | Initial slice |
| UC-04 | Open standalone menu and load a trusted encrypted credentials file. | Existing m-core decode/eval loads it within menu shell scope; selectable group becomes visible. | Initial slice; no credential algorithm retest |
| UC-05 | Deploy a service to a target server. | Validated desired state, execution through rsudo modules, verification and recorded result. | Future |
| UC-06 | Compare local resource configuration to observed remote state. | Accurate diff without mutations. | Future |
| UC-07 | Run unattended deployment. | Reuses existing rsudo unattended credential mechanism without secrets in JSON. | Future |

Acceptance mapping: [acceptance](acceptance.md).
