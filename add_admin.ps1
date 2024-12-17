net user /add test admin123
net localgroup "Administrators" test /add
net localgroup "Remote Desktop Users" test /add 
Write-Output "Local administrator account test created and added to the Administrators group."
