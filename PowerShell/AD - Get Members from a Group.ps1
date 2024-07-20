# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the name of the security group
$groupName = "Super Heroes"

# Get the members of the security group
$groupMembers = Get-ADGroupMember -Identity $groupName

# Display the list of members
foreach ($member in $groupMembers) {
    Write-Host $member.Name
}

##############################################################
# Ensure ImportExcel module is installed
if (!(Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Import the ImportExcel module
Import-Module ImportExcel

# Define the group name
$groupName = "Super Heroes"

# Get the group members
$groupMembers = Get-ADGroupMember -Identity $groupName

# Prepare an array to hold the members' names
$memberList = @()

# Collect members' names
foreach ($member in $groupMembers) {
    $memberList += [PSCustomObject]@{Name = $member.Name}
    Write-Host $member.Name
}

# Define the output file path
$outputFilePath = "C:\path\to\output\GroupMembers.xlsx"

# Export the members' names to an Excel file
$memberList | Export-Excel -Path $outputFilePath -AutoSize -Title "Group Members" -WorksheetName "Members"

# Confirm the export
Write-Host "Group members have been exported to $outputFilePath"
