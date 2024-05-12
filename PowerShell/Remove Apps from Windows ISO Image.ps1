<# 
.DESCRIPTION 
    Remove apps from Windows ISO image
	
.NOTES 
    Author     : Bernardo (BTNHD)
#> 
Install-Module -Name OSD -Force
Install-Module -Name OSDBuilder -Force

Set-ExecutionPolicy RemoteSigned -Force
Import-Module -Name OSDBuilder

# Specify Windows 11 23H2 ISO path, and edition to work with
$ISO = "$env:USERPROFILE\Downloads\XXXX.ISO"
$Edition = "Windows 11 Enterprise"

# Mount the Operating System ISO
Mount-DiskImage -ImagePath $ISO

# Import the media
Import-OSMedia -ImageName $Edition -SkipGrid

# Specify AppxPackages to Remove
$TaskName = "Remove Apps From Windows 11 22H2"
New-OSBuildTask -TaskName $TaskName -RemoveAppx

# Create a new OS Build 
# Note: Purposely skipping updates for OS and WinPE since the imported media was already updated
New-OSBuild -ByTaskName $TaskName -Execute -SkipComponentCleanup -SkipUpdates
