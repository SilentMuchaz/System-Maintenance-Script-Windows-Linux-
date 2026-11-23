# Windows System Maintenance Automation | PowerShell

I developed and executed a PowerShell script to automate routine Windows maintenance: temporary-file cleanup, DNS cache flushing, network-adapter restart requests, and software upgrades through Windows Package Manager (`winget`). The script captures console activity using PowerShell transcription.

The execution transcript confirms a successful DNS cache flush and **nine successful application installations/upgrades**. It records the cleanup and adapter-restart steps, but does not independently confirm their results.

## Recorded results

| Maintenance activity | Implementation | What the execution log establishes |
| --- | --- | --- |
| Temporary-file cleanup | `Remove-Item` on user and Windows temporary folders | Step was invoked; deletion totals and failures were not recorded |
| DNS cache reset | `ipconfig /flushdns` | **Success explicitly confirmed** |
| Network-adapter restart | `Get-NetAdapter` / `Restart-NetAdapter` | Step was invoked; successful restart was not independently verified |
| Application maintenance | `winget upgrade --all --silent` | **9/9 package operations reported successful installation** |
| Execution logging | `Start-Transcript` / `Stop-Transcript` | Timestamped PowerShell transcript captured the run |

### Software updated in the recorded run

| Application | Recorded outcome |
| --- | --- |
| Adobe Acrobat Reader | Installed successfully |
| Google Chrome | Installed successfully |
| PyCharm Professional | Uninstalled/reinstalled successfully during upgrade |
| Wireshark | Installed successfully |
| Microsoft Visual C++ Redistributable (x64) | Installed successfully |
| Microsoft Visual C++ Redistributable (x86) | Installed successfully |
| Telegram Desktop | Installed successfully |
| Visual Studio Code | Installed successfully |
| Windows Terminal | Installed successfully |

The run lasted **16 minutes 20 seconds** (11:17:39–11:33:59). This is the transcript duration, **not** a measured time saving or performance improvement.

## Implementation and tools

- **Language:** Windows PowerShell (`SystemCleanup.ps1`); the captured run reports PowerShell 5.1.
- **System commands:** `Remove-Item`, `ipconfig`, `Get-NetAdapter`, `Restart-NetAdapter`, `winget`.
- **Audit trail:** `Start-Transcript` records console output to `maintenance_log.txt`.
- **Platform scope:** **Windows only.** Although the repository name mentions Linux, the uploaded project contains no Linux shell script or Linux test evidence.

## Evidence

The key results above are drawn from the captured execution transcript, not estimated outcomes.

- [Sanitized maintenance run excerpt](evidence/maintenance-run-sanitized.txt)
- [Nine package outcomes (CSV)](evidence/upgrade-results.csv)
- [Technical case study](System-Maintenance-Case-Study.md) · [PDF report](01-windows-maintenance-case-study.pdf)
- [Execution screenshot from the original project (external link)](https://imgur.com/9oXkrZx.png)

```text
Flushing DNS cache...
Successfully flushed the DNS Resolver Cache.

(1/9) Found Adobe Acrobat Reader (64-bit) ...
Successfully installed
...
(9/9) Found Windows Terminal ...
Successfully installed
```

*Excerpt condensed from the supplied PowerShell transcript; see the sanitized log for the recorded package list.*

## Operational considerations

The original script is a **working prototype**, not a fully validated enterprise maintenance utility:

- It deletes temporary items with suppressed errors, so the transcript cannot confirm every deletion.
- It attempts to restart **all active adapters**, which can interrupt connectivity or remote support sessions.
- It runs **all available winget upgrades silently**, potentially changing multiple applications without per-package approval.
- Its completion message is printed regardless of whether every preceding operation succeeded.
- The original transcript contains local device/account information; the public evidence supplied here is redacted.

The original [`SystemCleanup.ps1`](SystemCleanup.ps1) is preserved unchanged as the code used for the recorded run. I also prepared an **optional, untested** [`SystemCleanup-Reviewed.ps1`](SystemCleanup-Reviewed.ps1) variant with explicit action switches, `-WhatIf`/confirmation support, append-only logging, and clearer warnings. **The reviewed variant has not been executed or validated on Windows.**

## Outcome

This project demonstrates PowerShell automation, Windows maintenance commands, package management, and execution-log analysis. The captured run verifies **DNS flushing and nine package upgrade outcomes**; other actions need additional before/after validation before their success can be claimed.
