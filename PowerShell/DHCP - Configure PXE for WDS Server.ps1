<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : DHCP - Configure PXE for WDS & SCCM Server
    Author     : Bernardo (BNTHD)
.LINK 

#> 
# Defining DHCP Vendor Classes
Add-DhcpServerv4Class -Name "PXEClient (UEFI x64)" -Type Vendor -Data "PXEClient:Arch:00007"

Add-DhcpServerv4Class -Name "PXEClient (UEFI x86)" -Type Vendor -Data "PXEClient:Arch:00006"

Add-DhcpServerv4Class -Name "PXEClient (BIOS x86 & x64)" -Type Vendor -Data "PXEClient:Arch:00000"


# Creating the DHCP Policies
Add-DhcpServerv4Policy -Name "PXEClient (UEFI x64)" -ScopeId 192.168.132.0 -Condition OR -VendorClass EQ,"PXEClient (UEFI x64)*"

Add-DhcpServerv4Policy -Name "PXEClient (UEFI x86)" -ScopeId 192.168.132.0 -Condition OR -VendorClass EQ,"PXEClient (UEFI x86)*"

Add-DhcpServerv4Policy -Name "PXEClient (BIOS x86 & x64)" -ScopeId 192.168.132.0 -Condition OR -VendorClass EQ,"PXEClient (BIOS x86 & x64)*"

# Configure DHCP Polices with 66
Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (UEFI x64)" -OptionId 066 -Value "192.168.132.140"

Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (UEFI x86)" -OptionId 066 -Value "192.168.132.140"

Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (BIOS x86 & x64)" -OptionId 066 -Value "192.168.132.140"

# Configure DHCP Polices with 67
Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (UEFI x64)" -OptionId 067 -Value "boot\x64\wdsmgfw.efi"

Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (UEFI x86)" -OptionId 067 -Value "boot\x86\wdsmgfw.efi"

Set-DhcpServerv4OptionValue -ScopeId 192.168.132.0 -PolicyName "PXEClient (BIOS x86 & x64)" -OptionId 067 -Value "boot\x64\wdsnbp.com"











