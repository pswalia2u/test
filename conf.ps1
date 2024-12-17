# powershell.exe -nop -exec bypass -c iex((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/pswalia2u/test/refs/heads/main/conf.ps1'))
net user /add test admin123
net localgroup "Administrators" test /add
net localgroup "Remote Desktop Users" test /add 
Write-Output "Local administrator account test created and added to the Administrators group."

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
