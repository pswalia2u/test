#Disable Alt Delete Keys
# Define the registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$regName = "Scancode Map"
$regValue = @(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x4d,0xe0,0x1d,0xe0,0x4b,0xe0,0x1d,0x00,0x00,0x00,0x00,0x00)

# Create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to disable Alt + Del keys
Set-ItemProperty -Path $regPath -Name $regName -Value ([byte[]]$regValue)

# Notify user
Write-Host "Alt + Del keys have been disabled. Please restart your computer for the changes to take effect."


# Enable keyboard volume control
$WshShell = New-Object -comObject WScript.Shell
$WshShell.SendKeys([char]174) # Volume Down
$WshShell.SendKeys([char]175) # Volume Up

#Anydesk Installation
# Define the URL and the destination path for the download
$downloadUrl = "https://download.anydesk.com/AnyDesk.exe"
$destinationPath = "c:\AnyDesk.exe"

# Download the AnyDesk installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

# Install AnyDesk with the specified parameters
Start-Process -FilePath $destinationPath -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --start-with-win --create-shortcuts --update-auto' -Wait

# Clean up by removing the installer
Remove-Item -Path $destinationPath


#Shutdown Scheduling
# The name of your scheduled task.  
$taskName = "Shutdown Computer"  
  
$User= "NT AUTHORITY\SYSTEM"  
  
# Describe the scheduled task.  
$description = "Shuts computer down daily at 10：00PM"  
  
# Create a new task action  
$taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument 'Stop-Computer -Force'  
  
#Create task trigger  
$taskTrigger = New-ScheduledTaskTrigger -Daily -At 10PM  
  
# Register the new PowerShell scheduled task  
# Register the scheduled task  
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Description $description -User $User 

