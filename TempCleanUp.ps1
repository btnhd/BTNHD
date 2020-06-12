<# 
    Description: Cleaning up TEMP folder
    Author: Bernardo Arocho | BTNHD
    Date: June 12, 2020

    Using -ErrorAction switch to disable all errors and continue to delete 
    inside the TEMP folder.     

#>

Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue