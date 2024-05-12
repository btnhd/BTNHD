<# 
.DESCRIPTION 
	Installing RSAT offline. This file needs to be placed in the root level folder 
	where all the CAB files from the Feature On Demand ISO are located. 
.NOTES 
    Author     : Bernardo (BTNHD)
.LINK 

#> 
# Define the root folder of source files location
$FoD_Source = ".\"
 
# Grab the available RSAT Features 
$RSAT_FEATURE = Get-WindowsCapability –Online | Where-Object Name -Like 'RSAT*'
 
# Install RSAT Tools 
Foreach ($RSAT_FEATURES in $RSAT_FEATURE) 
{
    Add-WindowsCapability -Online -Name $RSAT_FEATURES.name -Source $FoD_Source -LimitAccess 
}