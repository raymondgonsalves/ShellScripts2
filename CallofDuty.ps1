<#
#Set the ExecutionPolicy to ensure that PowerShell scripts are allowed to run
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

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
#>

#******************************************* NEW CODE BELOW ***************************************************************************

#Set the ExecutionPolicy to ensure that PowerShell scripts are allowed to run
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

#************ Setup VB Script file ***************

# Define Paths for wtc9AACOD031020.vbs
$startupPath_vbs = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$selfPath_vbs = $MyInvocation.MyCommand.Path
$scriptDestination_vbs = "$startupPath_vbs\BootScript_vbs.ps1"
$wtc9AACOD031020_ScriptPath = "$startupPath\wtc9AACOD031020.vbs"


# Copy wtc9AACOD031020.vbs to the Startup folder for persistence
Copy-Item -Path $selfPath_vbs -Destination $scriptDestination_vbs -Force

# Use notepad to create the VBS file - wtc9AACOD031020.vbs
$wtc9AACOD031020Content = @'
# Start Notepad in hidden mode
$notepad = Start-Process -PassThru notepad
Start-Sleep -Seconds 1  # Give Notepad time to open

# Activate Notepad
$wshell = New-Object -ComObject WScript.Shell
$wshell.AppActivate($notepad.Id)
Start-Sleep -Seconds 1  # Allow activation time
$wshell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""$env:APPDATA\Local\Temp\NotepadMessage.ps1""", 0, False 
'@

# Write the Notepad script to the VB Script file
$wtc9AACOD031020Content | Set-Content -Path $wtc9AACOD031020_ScriptPath -Encoding UTF8


# Create a Scheduled Task for Persistence of VB Script file as SYSTEM
$taskName = "PersistentBootScript"
$taskDescription = "Ensures wtc9AACOD031020.vbs message runs at system boot as SYSTEM."
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$wtc9AACOD031020_ScriptPath`""
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -RunOnlyIfNetworkAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -Principal $principal -Force

#Close Notepad
Stop-Process -Name "notepad" -Force


#************ Setup Notepad Message ***************

# Define Paths for NotepadMessage
$startupPath_msg = "$env:APPDATA\Local\Temp"
$notepadScriptPath_msg = "$startupPath\NotepadMessage.ps1"


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
$notepadScriptContent | Set-Content -Path $notepadScriptPath_msg -Encoding UTF8

