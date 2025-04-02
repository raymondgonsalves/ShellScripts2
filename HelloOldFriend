# Define Paths
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$selfPath = $MyInvocation.MyCommand.Path
$scriptDestination = "$startupPath\BootScript.ps1"
$notepadScriptPath = "$startupPath\NotepadMessage.ps1"

# Copy this script to the Startup folder for persistence
Copy-Item -Path $selfPath -Destination $scriptDestination -Force

# Create the Notepad Message Script
$notepadScriptContent = @'
Start-Process notepad
Start-Sleep -Seconds 1
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys("Hello again Old Friend")
'@

# Write the Notepad script to a file
$notepadScriptContent | Set-Content -Path $notepadScriptPath -Encoding UTF8

# Create a Scheduled Task for Persistence
$taskName = "PersistentBootScript"
$taskDescription = "Ensures Notepad message runs at system boot."
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$notepadScriptPath`""
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -User "$env:UserName" -RunLevel Highest -Force

# Run the Notepad script immediately
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$notepadScriptPath`""
