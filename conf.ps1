# powershell.exe -nop -exec bypass -c iex((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/pswalia2u/test/refs/heads/main/conf.ps1'))
#Adding Local Admin User
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

#Setting up proxy before autopilot onboarding
<#
$proxyAddress = "http:// 193.61.220.3:80" 
netsh winhttp set proxy $proxyAddress
# Set the proxy settings for the user (optional) 
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $proxyAddress 
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value
#>

Install-Script -Name Get-WindowsAutopilotInfo -Force -Confirm:$false
# Run the script to collect Autopilot info and upload it with a group tag, bypassing prompts 
Get-WindowsAutopilotInfo.ps1 -online -GroupTag Kiosk_ps -Force -Confirm:$false

#Disable Translate popup for msedge
# Define the registry path for Edge settings
$EdgeSettingsPath = "HKLM:\Software\Policies\Microsoft\Edge"
# Create the registry key if it doesn't exist
if (-Not (Test-Path $EdgeSettingsPath)) {
    New-Item -Path $EdgeSettingsPath -Force
}
# Set the policy to disable the translation popup
Set-ItemProperty -Path $EdgeSettingsPath -Name "TranslateEnabled" -Value 0 -Type DWord
Write-Output "Translation popup has been disabled in Microsoft Edge for all users."
