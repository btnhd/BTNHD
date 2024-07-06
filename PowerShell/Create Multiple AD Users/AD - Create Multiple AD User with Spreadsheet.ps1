Install-Module -Name ImportExcel -Scope CurrentUser -Force -SkipPublisherCheck
#Install-Module -Name ActiveDirectory

Import-Module ActiveDirectory
Import-Module ImportExcel

$excelFilePath = "E:\USERS\users.xlsx"

$data = Import-Excel -Path $excelFilePath

foreach ($row in $data) 
{
    $firstName = $row.FirstName
    $lastName = $row.LastName
    $password = $row.Password
    $ouPath = "OU=USERS,OU=BTNHD,DC=btnhd,DC=edu" 
    $groups = $row.Groups -split ";"

    $username = ($firstName + "." + $lastName).ToLower()
    $displayName = "$firstName $lastName"
    $email = "$username@btnhd.edu"

    New-ADUser -GivenName $firstName `
               -Surname $lastName `
               -Name "$displayName" `
               -SamAccountName $username `
               -UserPrincipalName "$email" `
               -DisplayName $displayName `
               -EmailAddress $email `
               -Path $ouPath `
               -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
               -Enabled $true

    foreach ($group in $groups) 
    {
        $group = $group.Trim()
        if ($group -ne "") 
        {
            Add-ADGroupMember -Identity $group -Members $username
            Write-Host -ForegroundColor Red "Added $username to group $group"
        } #end of IF
    } #end of inner FOREACH loop

    Write-Host -ForegroundColor Yellow "Created user $username and added to specified groups"
} #end of global FOREACH loop

Write-Host -ForegroundColor Green "Script execution completed."