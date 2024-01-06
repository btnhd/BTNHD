<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : AD - Reset User Password in Active Directory
    Author     : Bernardo Arocho
.LINK 

#> 
Import-Module ActiveDirectory

Get-Command -Module ActiveDirectory

$Pass = ConvertTo-SecureString "!20btnhd24!" -AsPlainText -Force

Set-ADAccountPassword -Identity bruce.wayne -NewPassword $pass –Reset

Set-ADUser -Identity bruce.wayne -ChangePasswordAtLogon $true