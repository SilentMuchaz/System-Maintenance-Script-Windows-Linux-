<#
.SYNOPSIS
  Opt-in, review-oriented Windows maintenance script.
.DESCRIPTION
  Safer alternative to the original SystemCleanup.ps1. No maintenance actions
  occur unless their switches are supplied. Supports -WhatIf and -Confirm.
  This variant was prepared through static review; it has NOT been executed
  or validated on Windows in this project.
.EXAMPLE
  .\SystemCleanup-Reviewed.ps1 -FlushDns -WhatIf
.EXAMPLE
  .\SystemCleanup-Reviewed.ps1 -ClearTemp -FlushDns -Confirm
.NOTES
  Restarting an active adapter can disconnect remote sessions. App upgrades
  can change installed software and require additional prompts/reboots.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [switch]$ClearTemp,
    [switch]$FlushDns,
    [switch]$RestartAdapters,
    [switch]$UpdateApps,
    [string]$LogPath = (Join-Path $PSScriptRoot 'maintenance-reviewed.log')
)

$ErrorActionPreference = 'Stop'

if (-not ($ClearTemp -or $FlushDns -or $RestartAdapters -or $UpdateApps)) {
    Write-Host 'No actions selected. Specify one or more maintenance switches.'
    return
}

$transcriptStarted = $false
try {
    Start-Transcript -Path $LogPath -Append -ErrorAction Stop | Out-Null
    $transcriptStarted = $true
    Write-Host 'Windows maintenance: selected operations only.'

    if ($ClearTemp) {
        foreach ($directory in @($env:TEMP, (Join-Path $env:WINDIR 'Temp'))) {
            if ([string]::IsNullOrWhiteSpace($directory) -or -not (Test-Path -LiteralPath $directory)) {
                continue
            }
            foreach ($item in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
                if ($PSCmdlet.ShouldProcess($item.FullName, 'Delete temporary item')) {
                    try {
                        Remove-Item -LiteralPath $item.FullName -Force -Recurse -ErrorAction Stop
                        Write-Host "Removed: $($item.FullName)"
                    } catch {
                        Write-Warning "Could not remove $($item.FullName): $($_.Exception.Message)"
                    }
                }
            }
        }
    }

    if ($FlushDns -and $PSCmdlet.ShouldProcess('DNS resolver cache', 'Flush')) {
        & ipconfig.exe /flushdns
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "DNS flush returned exit code $LASTEXITCODE."
        }
    }

    if ($RestartAdapters) {
        foreach ($adapter in @(Get-NetAdapter -ErrorAction Stop | Where-Object { $_.Status -eq 'Up' })) {
            if ($PSCmdlet.ShouldProcess($adapter.Name, 'Restart active network adapter')) {
                try {
                    Restart-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
                    Write-Host "Restart requested: $($adapter.Name)"
                } catch {
                    Write-Warning "Adapter restart failed for $($adapter.Name): $($_.Exception.Message)"
                }
            }
        }
    }

    if ($UpdateApps) {
        $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
        if (-not $winget) {
            Write-Warning 'winget.exe was not found; app upgrades skipped.'
        } elseif ($PSCmdlet.ShouldProcess('Installed winget packages', 'Upgrade all available packages')) {
            & $winget.Source upgrade --all --silent
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "winget returned exit code $LASTEXITCODE."
            }
        }
    }
} finally {
    if ($transcriptStarted) {
        Stop-Transcript | Out-Null
    }
}
