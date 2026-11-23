# Windows System Maintenance — Execution Case Study

## Project objective

Automate a set of routine Windows maintenance operations through PowerShell, capture execution output, and evaluate which outcomes can be verified from the resulting log.

## Environment and artifacts

- **Operating system:** Windows, build `10.0.26100.0` as reported by the transcript.
- **PowerShell:** Windows PowerShell `5.1.26100.4484`.
- **Script:** `SystemCleanup.ps1` (original code preserved).
- **Execution evidence:** PowerShell transcript dated **31 July 2025**; run time **11:17:39–11:33:59** (16 minutes 20 seconds).
- **Utilities:** PowerShell file-system and networking cmdlets, `ipconfig`, and Windows Package Manager (`winget`).

The repository contains a Windows PowerShell implementation. It does not contain a Linux maintenance script or Linux execution results.

## Implemented operations

| Operation | Script implementation | Recorded result |
| --- | --- | --- |
| Temporary-folder cleanup | `Remove-Item` for `$env:TEMP` and `C:\Windows\Temp` | Cleanup step appears in transcript; no file counts or per-file outcomes |
| DNS resolver cache | `ipconfig /flushdns` | Explicit success message captured |
| Active network adapters | `Get-NetAdapter` filtered to `Up`, piped to `Restart-NetAdapter` | Restart step appears; no before/after adapter state |
| Installed application upgrades | `winget upgrade --all --silent` | Nine packages reported `Successfully installed` |
| Logging | `Start-Transcript` and `Stop-Transcript` | Start and end times recorded in transcript |

## Evidence-backed results

### DNS cache flush

The transcript contains `Successfully flushed the DNS Resolver Cache.` following the `ipconfig /flushdns` invocation. This supports the conclusion that the DNS cache flush completed successfully.

### Application maintenance

The transcript lists nine package operations, each followed by `Successfully installed`. The package set includes Adobe Acrobat Reader, Chrome, PyCharm Professional, Wireshark, both x64 and x86 Microsoft Visual C++ Redistributables, Telegram Desktop, Visual Studio Code, and Windows Terminal. The PyCharm entry also records a successful uninstall as part of its upgrade process.

These are **installer outcomes recorded by winget**, not a separate post-upgrade version audit or system health assessment.

### Temporary-file cleanup and adapter restart

Both steps appear in the transcript. However, the script suppresses errors for temporary-file deletion, and the transcript does not include a count of deleted items or adapter state checks. The evidence therefore supports **attempted execution**, not independently confirmed success.

## Operational review

1. **Verification gap:** No pre/post metrics for temporary-file counts, adapter state, free disk space, or overall system performance.
2. **Change risk:** Restarting all active network adapters can disrupt a connected user or remote administration session.
3. **Change scope:** `winget upgrade --all --silent` applies all available upgrades, potentially without change windows or package-specific approvals.
4. **Error handling:** The script prints a completion message even if a step silently fails.
5. **Privacy:** The original transcript contains local user, machine and path data; the public excerpt omits these identifiers.

## Improvement prepared (not executed)

An optional `SystemCleanup-Reviewed.ps1` variant separates maintenance actions behind explicit switches and supports PowerShell `-WhatIf`/confirmation, append-only logging, and warnings. It is a **proposed code improvement** only; the repository does not include a Windows execution test of that variant.

## Outcome and next validation

**Verified:** PowerShell transcription, successful DNS flush, and nine reported successful package installations/upgrades during the recorded run.

**Not independently verified:** Number of temporary files deleted, network-adapter restart success, performance improvement, reduced ticket handling time, and any Linux functionality.

A future validation run could capture before/after temporary-file counts, adapter state, application versions, exit codes, and controlled execution under `-WhatIf` before making stronger operational claims.

## Evidence artifacts

- [Original implementation](SystemCleanup.ps1)
- [Sanitized transcript excerpt](evidence/maintenance-run-sanitized.txt)
- [Package outcome table](evidence/upgrade-results.csv)
- [Optional reviewed variant (not tested)](SystemCleanup-Reviewed.ps1)
