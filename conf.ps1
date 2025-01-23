# powershell.exe -nop -exec bypass -c "iex((New-Object Net.WebClient).DownloadString('script-URL'))"
 
# powershell.exe -nop -exec bypass -c "iex((New-Object Net.WebClient).DownloadString('file:///e:\conf.ps1'))"
 
Write-Output "Version 1.0 20/12/24 1540"
 
#Adding Local Admin User
net user /add test admin123
net localgroup "Administrators" test /add
net localgroup "Remote Desktop Users" test /add 
Write-Output "Local administrator account test created and added to the Administrators group."
 
#Anydesk Installation
try {
    # Download the AnyDesk installer
  #  Invoke-WebRequest -Uri "https://download.anydesk.com/AnyDesk.exe" -OutFile "c:\AnyDesk.exe" -ErrorAction Stop
  #  Write-Output "AnyDesk installer downloaded successfully."
 
    # Install AnyDesk with the specified parameters
    Start-Process -FilePath "e:\AnyDesk.exe" -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --start-with-win --create-shortcuts --update-auto' -Wait -ErrorAction Stop
    Write-Output "AnyDesk installed successfully."
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    # Clean up by removing the installer
    if (Test-Path "c:\AnyDesk.exe") {
        Remove-Item -Path "c:\Users\Cyfrifiaduron\Desktop\AnyDesk.exe" -ErrorAction SilentlyContinue
        Write-Output "Installer cleaned up."
    }
}

#Shutdown Scheduling
# The name of your scheduled task.  
$taskName = "Shutdown Computer"  
$User= "NT AUTHORITY\SYSTEM" 
# Describe the scheduled task.  
$description = "Shuts computer down daily at 10:00PM"
# Create a new task action  
$taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument 'Stop-Computer -Force' 
#Create task trigger  
$taskTrigger = New-ScheduledTaskTrigger -Daily -At 10PM  
# Register the new PowerShell scheduled task
# Register the scheduled task  
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Description $description -User $User 
 
#Setting up proxy before autopilot onboarding
# Enable Proxy Server for all users
try {
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1 -ErrorAction Stop
    Write-Output "Proxy server enabled successfully for all users."
} catch {
    Write-Error "Failed to enable proxy server for all users. Error: $_"
}
 
# Set Proxy Server Address and Port for all users
try {
    $proxyAddress = "193.61.220.3:80"
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $proxyAddress -ErrorAction Stop
    Write-Output "Proxy server address set to $proxyAddress for all users."
} catch {
    Write-Error "Failed to set proxy server address for all users. Error: $_"
}
 
# Set new proxy exceptions for all users
try {
    $newExceptions = "*.llfrgell.cymru;*.llgc.org.uk"
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyOverride -Value $newExceptions -ErrorAction Stop
    Write-Output "Proxy exceptions set to $newExceptions for all users."
} catch {
    Write-Error "Failed to set proxy exceptions for all users. Error: $_"
}
 
# Enable Proxy Server for current user
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1 -ErrorAction Stop
    Write-Output "Proxy server enabled successfully for current user."
} catch {
    Write-Error "Failed to enable proxy server for current user. Error: $_"
}
 
# Set Proxy Server Address and Port for current user
try {
    $proxyAddress = "193.61.220.3:80"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $proxyAddress -ErrorAction Stop
    Write-Output "Proxy server address set to $proxyAddress for current user."
} catch {
    Write-Error "Failed to set proxy server address for current user. Error: $_"
}
 
# Set new proxy exceptions for current user
try {
    $newExceptions = "*.llfrgell.cymru;*.llgc.org.uk"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyOverride -Value $newExceptions -ErrorAction Stop
    Write-Output "Proxy exceptions set to $newExceptions for current user."
} catch {
    Write-Error "Failed to set proxy exceptions for current user. Error: $_"
}
 
 
Write-Output "Installing Get-WindowsAutopilotInfo script from powershellgallery.com"
#Install-Script -Name Get-WindowsAutopilotInfo -Scope AllUsers -Force -Confirm:$false
Start-Process -FilePath "powershell.exe" -ArgumentList " -Command Install-Script -Name Get-WindowsAutopilotInfo -Scope AllUsers -Force -Confirm:`$false" -Wait
Write-Output "Sleeping for 5 seconds"
Start-Sleep -Seconds 5
Write-Output "Getting loggedin. Running 'Get-WindowsAutopilotInfo.ps1 -online -GroupTag NBA_BAC'"
& "C:\Program Files\WindowsPowerShell\Scripts\Get-WindowsAutopilotInfo.ps1" -online -GroupTag NBA_BAC
#OrderID = GroupTag
