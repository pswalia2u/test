# Define the username and password for the new local administrator account
$username = "admin"
$password = "admin123"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create the new local user account
New-LocalUser -Name $username -Password $securePassword -FullName "New Local Administrator" -Description "Local Administrator Account"

# Add the new user to the local administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username

Write-Output "Local administrator account '$username' created and added to the Administrators group."

net user /add test admin123
net localgroup "Administrators" test /add
net localgroup "Remote Desktop Users" test /add 