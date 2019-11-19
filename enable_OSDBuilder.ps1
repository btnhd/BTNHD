$ISO_PATH = "C:\Users\btnhd\Downloads\SW_DVD9_Win_Server_STD_CORE_2019_1809.2_64Bit_English_DC_STD_MLF_X22-18452.ISO"

#Install-Module -Name OSDBuilder -Force
#Import-Module -Name OSDBuilder -Force

Mount-DiskImage -ImagePath $ISO_PATH
Import-OSMedia -ImageName 'Windows Server 2019 Standard (Desktop Experience)' -SkipGridView -UpdateOSMedia

New-OSBuildTask -TaskName "BTNHD Windows Server 2019 Enable NetFX3" -EnableNetFX3

New-OSBuild -Download -Execute -ByTaskName "BTNHD Windows Server 2019 Enable NetFX3"

New-OSBMediaISO