# m-rsudo

Source repository for the existing technical `rsudo` subsystem: `rsudo`, `rsudo-admin`, `rssh`, the `rsudo/` library modules and their operational manuals, including existing administration backends. Sources preserve their original relative runtime paths at extraction.

Its actual external dependencies include terminal menu and the shared `m` shell/SSH/credential libraries. Nothing here stores host credentials. Packaging through the current `pkg` contracts and real SSH/sudo validation remain to be completed; a source import alone is not a runnable installation.
