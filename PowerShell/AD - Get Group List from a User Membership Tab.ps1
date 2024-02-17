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

# Use the below comment to export it out into a CSV file (make sure to change the file path to your location)
#$UserData = Write-Output "Groups for $userName - " | Out-File -FilePath "C:\BTNHD_TEMP\$userName-GroupList.csv" -Append
foreach ($group in $user.MemberOf) {
    $groupName = (Get-ADGroup $group).Name
    Write-Host "$groupName;"
	
	# Use the below comment to export it out into a CSV file (make sure to change the file path to your location)
	#Write-Output "$groupName;" | Out-File -FilePath "C:\BTNHD_TEMP\$userName-GroupList.csv" -Append
}