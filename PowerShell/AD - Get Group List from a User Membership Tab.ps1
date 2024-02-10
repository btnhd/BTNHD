<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : Get Group List from a User's Memebership Tab
    Author     : Bernardo (BNTHD)
.LINK 

#> 

# Import Active Directory Module into PowerShell
Import-Module ActiveDirectory

# Specify the username or user's DistinguishedName
$userName = "Bruce.Wayne"

# Get the user object
$user = Get-ADUser -Identity $userName -Properties MemberOf

# Display user's group memberships
$UserData = Write-Host "Groups for $userName - "
foreach ($group in $user.MemberOf) {
    $groupName = (Get-ADGroup $group).Name
    Write-Host "$groupName;"
}