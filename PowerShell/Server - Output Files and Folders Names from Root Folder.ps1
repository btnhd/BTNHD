<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : Output file and folders names from root folder
    Author     : Bernardo (BTNHD)
.LINK 

#> 
# Set the path to the root folder you want to analyze
$rootFolder = "C:\Users\bernardo.arocho\Desktop\FILES"

# Specify the output CSV file
$outputFile = "$env:USERPROFILE\Downloads\File.csv"

# Retrieve directory information and export to CSV
Get-ChildItem -Path $rootFolder -File -Recurse | ForEach-Object {
    [PSCustomObject]@{
        FolderName = $_.Directory.Name
        SubfolderName = $_.DirectoryName -replace [regex]::Escape($rootFolder), ""
        FileName = $_.Name
        FullPath = $_.FullName
    }
} | Export-Csv -Path $outputFile -NoTypeInformation