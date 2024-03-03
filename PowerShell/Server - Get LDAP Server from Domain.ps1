<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : Get LDAP Server from Domain
    Author     : Bernardo (BNTHD)
.LINK 

#> 
# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the domain you want to search in
$domain = "btnhd.edu"

# Get LDAP Server from the domain (quick and easy way to get the information needed)
#Get-ADDomainController -Discover -DomainName $domain

# Adding logic to discover the LDAP server for the domain and out putting it as text
try {
    $ldapServer = Get-ADDomainController -Discover -DomainName $domain
    Write-Host "LDAP Server found:"
    Write-Host "Server Name: $($ldapServer.Name)"
    Write-Host "Server HostName: $($ldapServer.HostName)"
	Write-Host "Server IP: $($ldapServer.IPv4Address)"
    Write-Host "Server Site: $($ldapServer.Site)"
} catch {
    Write-Host "Error locating LDAP server: $_"
}
