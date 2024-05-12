<# 
.DESCRIPTION 
	Defining the ISO file and path to extract the RSAT content into
	a temp folder. This temp folder will be the folder to import into 
	your deployment server.
.NOTES 
    Author     : Bernardo (BTNHD)
.LINK 

#> 
# specify the location of the Features On Demand ISO location 
$ISO_Source = "$env:USERPROFILE\Downloads\SW_DVD9_Win_11_22H2_x64_MultiLang_LangPackAll_LIP_LoF_X23-12645.iso"
 
# Mount Features On Demand ISO file and grab the drive letter where it was mounted
Mount-DiskImage -ImagePath "$ISO_Source" 
$path = (Get-DiskImage "$ISO_Source" | Get-Volume).DriveLetter
 
# define your desired Language
$lang = "en-US" 

# creates a temp RSAT folder  
$dest = New-Item -ItemType Directory -Path "$env:SystemDrive\temp\RSAT_$lang" -force
 
# get all the RSAT files  
Get-ChildItem ($path+":\") -name -recurse -include *~amd64~~.cab,*~wow64~~.cab,*~amd64~$lang~.cab,*~wow64~$lang~.cab -exclude *languagefeatures*,*Holographic*,*NetFx3*,*OpenSSH*,*Msix* |
ForEach-Object {copy-item -Path ($path+“:\”+$_) -Destination $dest.FullName -Force -Container}
 
# get metadata for Features On Demand
copy-item ($path+":\LanguagesAndOptionalFeatures\metadata") -Destination $dest.FullName -Recurse 
copy-item ($path +“:\LanguagesAndOptionalFeatures\"+“FoDMetadata_Client.cab”) -Destination $dest.FullName -Force -Container
 
#Dismount the ISO when the copying is compeleted
Dismount-DiskImage -ImagePath "$ISO_Source"