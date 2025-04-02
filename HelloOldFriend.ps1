# Define Paths
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$selfPath = $MyInvocation.MyCommand.Path
$scriptDestination = "$startupPath\BootScript.ps1"
$WordpadScriptPath = "$startupPath\WordpadMessage.ps1"

# Copy itself to the Startup folder for persistence
Copy-Item -Path $selfPath -Destination $scriptDestination -Force

# Create the Wordpad Message Script
# Start WordPad
$wordpad = Start-Process -PassThru write
Start-Sleep -Seconds 2  # Allow WordPad to open

# Activate WordPad
$wshell = New-Object -ComObject WScript.Shell
$wshell.AppActivate($wordpad.Id)
Start-Sleep -Seconds 1  # Allow activation time

# Select all text and delete any existing content
$wshell.SendKeys("^a")  
Start-Sleep -Milliseconds 500  
$wshell.SendKeys("{DEL}")  
Start-Sleep -Milliseconds 500  

# Type the text
$wshell.SendKeys("Hello again Old Friend")  

# Select the text to apply formatting
Start-Sleep -Milliseconds 500  
$wshell.SendKeys("^a")  

# Open the font settings (Ctrl + D)
Start-Sleep -Milliseconds 500  
$wshell.SendKeys("^d")  
Start-Sleep -Seconds 1  

# Set font family to Arial
$wshell.SendKeys("Arial")  
Start-Sleep -Milliseconds 500  
$wshell.SendKeys("{TAB}")  # Move to font size  
$wshell.SendKeys("55")  # Set font size  
Start-Sleep -Milliseconds 500  
$wshell.SendKeys("{ENTER}")  # Apply settings

'@

# Write the Wordpad script to a file
$WordpadScriptContent | Set-Content -Path $WordpadScriptPath -Encoding UTF8

# Create a Scheduled Task for Persistence as SYSTEM
$taskName = "PersistentBootScript"
$taskDescription = "Ensures Wordpad message runs at system boot as SYSTEM."
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$WordpadScriptPath`""
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -RunOnlyIfNetworkAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -Principal $principal -Force

# Run the Wordpad script immediately, hidden
Start-Process -WindowStyle Hidden powershell 
