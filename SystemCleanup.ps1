$log = "$PSScriptRoot\maintenance_log.txt"
Start-Transcript -Path $log

Write-Host "🧹 Starting System Cleanup..." -ForegroundColor Green

# 1. Clear Temp Files
Write-Host "Clearing temp files..."
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# 2. Flush DNS Cache
Write-Host "Flushing DNS cache..."
ipconfig /flushdns

# 3. Restart Network Adapter
Write-Host "Restarting network adapter..."
Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Restart-NetAdapter -Confirm:$false

# 4. Update Installed Software (via Winget)
Write-Host "Updating installed software using winget..."
winget upgrade --all --silent

Write-Host "✅ Cleanup Complete." -ForegroundColor Cyan

Stop-Transcript
