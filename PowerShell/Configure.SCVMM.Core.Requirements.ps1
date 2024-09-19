<#
.SYNOPSIS
 
A script used for configuring the required software prerequisites to set up an SCVMM management server (2022).
 
.DESCRIPTION
 
A script used for configuring the required software prerequisites to set up an SCVMM management server (2022).
This script will do all of the following:
 
Check if PowerShell runs as Administrator, otherwise, exit the script.
Create the C:\Temp folder if it does not already exist.
Download all .exe and .msi files to the C:\Temp folder.
Install Microsoft Visual C++ Redistributable.
Install ODBC Driver for SQL Server.
Install Microsoft Command Line Utilities 15 for SQL Server.
Install Windows Assessment and Deployment Kit (ADK).
Install WinPE Addon for Windows ADK.
Clean up all .exe and .msi files in the C:\Temp folder.
Write script completed, and a server reboot will take place.
 
.NOTES
 
Filename:       Configure.SCVMM.Core.Requirements.ps1 (change by Bernardo Arocho 05.11.2024)
Created:        28/08/2023
Last modified:  28/08/2023
Author:         Wim Matthyssen
Version:        1.0
PowerShell:     5.1
Action:         Change variables were needed to fit your needs. 
Disclaimer:     This script is provided "As Is" with no warranties.
 
.EXAMPLE
 
.\Configure.SCVMM.Core.Requirements.ps1 (change by Bernardo Arocho 05.11.2024)
 
.LINK
 
https://wmatthyssen.com/2022/06/03/azure-arc-azure-powershell-prerequisites-configuration-script/
#>
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Variables
$tempFolderName = "Temp"
$tempFolder = "C:\" + $tempFolderName +"\"
$itemType = "Directory"
 
$visualC2017x86Url = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
$visualC2017x86Exe = $tempFolder + "VC_redist.x86.exe"
$visualC2017x64Url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$visualC2017x64Exe = $tempFolder + "VC_redist.x64.exe"
$msodbcsqlUrl = "https://go.microsoft.com/fwlink/?linkid=2239168"
$msodbcsqlMsi = $tempFolder + "msodbcsql.msi"
$msSqlCmdLnUtilsUrl = "https://go.microsoft.com/fwlink/?linkid=2230791"
$msSqlCmdLnUtilsMsi = $tempFolder + "MsSqlCmdLnUtils.msi"
$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2196127"
$adkExe = $tempFolder + "adksetup.exe"
$adkWinPeUrl = "https://go.microsoft.com/fwlink/?linkid=2196224"
$adkWinPeExe = $tempFolder + "adkwinpesetup.exe"
 
Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"} | Out-Null
$foregroundColor1 = "Green"
$foregroundColor2 = "Yellow"
$foregroundColor3 = "Red"
$foregroundColor4 = "Magenta"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Check if PowerShell runs as Administrator, otherwise, exit the script
 
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
 
# Check if running as Administrator, otherwise exit the script
         
if ($isAdministrator -eq $false) {
        Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperatorSpaces + $currentTime)`
        -foregroundcolor $foregroundColor3 $writeEmptyLine
        Start-Sleep -s 3
        exit
} else {  
        Write-Host ($writeEmptyLine + "# Script started. Without any errors, it will need around 2 minutes to complete" + $writeSeperatorSpaces + $currentTime)`
        -foregroundcolor $foregroundColor1 $writeEmptyLine
}
   
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create the C:\Temp folder if it does not already exist
 
If(!(test-path $tempFolder))
{
New-Item -Path "C:\" -Name $tempFolderName -ItemType $itemType -Force | Out-Null
}
 
Write-Host ($writeEmptyLine + "# $tempFolderName folder available" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download all .exe and .msi files to the C:\Temp folder
 
Invoke-WebRequest -Uri $visualC2017x86Url -OutFile $visualC2017x86Exe
Invoke-WebRequest -Uri $visualC2017x64Url -OutFile $visualC2017x64Exe
Invoke-WebRequest -Uri $msodbcsqlUrl -OutFile $msodbcsqlMsi
Invoke-WebRequest -Uri $msSqlCmdLnUtilsUrl -OutFile $msSqlCmdLnUtilsMsi
Invoke-WebRequest -Uri $adkUrl -OutFile $adkExe
Invoke-WebRequest -Uri $adkWinPeUrl -OutFile $adkWinPeExe
 
Write-Host ($writeEmptyLine + "# All .exe and .msi files are available in the $tempFolderName folder" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
  
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install Microsoft Visual C++ Redistributable (x86)
 
Write-Host ($writeEmptyLine + "# Installing Microsoft Visual C++ Redistributable (x86) ... ") -ForegroundColor $foregroundColor4
Start-Process -Wait -FilePath $visualC2017x86Exe -ArgumentList '/S','/v','/qn','/norestart' -passthru | Out-Null
 
Write-Host ($writeEmptyLine + "# Microsoft Visual C++ Redistributable x86 installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install Microsoft Visual C++ Redistributable (x64)
 
Write-Host ($writeEmptyLine + "# Installing Microsoft Visual C++ Redistributable (x64) ... ") -ForegroundColor $foregroundColor4
Start-Process -Wait -FilePath $visualC2017x64Exe -ArgumentList '/S','/v','/qn','/norestart' -passthru | Out-Null
 
Write-Host ($writeEmptyLine + "# Microsoft Visual C++ Redistributable x64 installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install ODBC Driver for SQL Server
 
Write-Host ($writeEmptyLine + "# Installing ODBC Driver for SQL Server ... ") -ForegroundColor $foregroundColor4
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Temp\msodbcsql.msi" REBOOT=ReallySuppress IACCEPTMSODBCSQLLICENSETERMS=YES /qb /quiet'
 
Write-Host ($writeEmptyLine + "# ODBC Driver for SQL Server installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install Microsoft Command Line Utilities 15 for SQL Server
 
Write-Host ($writeEmptyLine + "# Installing Microsoft Command Line Utilities 15 for SQL Server ... ") -ForegroundColor $foregroundColor4
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Temp\MsSqlCmdLnUtils.msi" REBOOT=ReallySuppress IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES /qb /quiet'
 
Write-Host ($writeEmptyLine + "# Microsoft Command Line Utilities 15 for SQL Server installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install Windows Assessment and Deployment Kit (ADK)
 
$setupSwitchesAdk = "/Features OptionId.DeploymentTools /norestart /quiet /ceip off"
 
Write-Host ($writeEmptyLine + "# Installing Windows Assessment and Deployment Kit (ADK) ... ") -ForegroundColor $foregroundColor4
Start-Process -FilePath $adkExe -ArgumentList $setupSwitchesAdk -NoNewWindow -Wait
 
Write-Host ($writeEmptyLine + "# Windows Assessment and Deployment Kit (ADK) installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Install WinPE Addon for Windows ADK
 
$setupSwitchesPe = "/Features OptionId.WindowsPreinstallationEnvironment /norestart /quiet /ceip off"
 
Write-Host ($writeEmptyLine + "# Installing WinPE Addon for Windows ADK ... ") -ForegroundColor $foregroundColor4
Start-Process -FilePath $adkWinPeExe -ArgumentList $setupSwitchesPe -NoNewWindow -Wait
 
Write-Host ($writeEmptyLine + "# WinPE Addon for Windows ADK installed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Clean up all .exe and .msi files in the C:\Temp folder
 
Remove-Item -Path $visualC2017x86Exe
Remove-Item -Path $visualC2017x64Exe
Remove-Item -Path $msodbcsqlMsi
Remove-Item -Path $msSqlCmdLnUtilsMsi
Remove-Item -Path $adkExe
Remove-Item -Path $adkWinPeExe
 
Write-Host ($writeEmptyLine + "# All .exe and .msi files are cleaned up in the $tempFolderName folder" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Write script completed, and a server reboot will take place
 
Write-Host ($writeEmptyLine + "# The script has finished running, and now a server reboot is being initiated to implement all the changes" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
# Wait 3 seconds and then restart the server
Start-Sleep 3

# Prompt user for reboot with a pop-up
Add-Type -AssemblyName PresentationFramework

$reboot = [System.Windows.MessageBox]::Show('Do you want to reboot now?', 'Reboot Prompt', 'YesNo', 'Question')

if ($reboot -eq 'Yes') {
    Restart-Computer
} else {
    [System.Windows.MessageBox]::Show('Reboot canceled.', 'Reboot Prompt', 'OK', 'Information')
}
