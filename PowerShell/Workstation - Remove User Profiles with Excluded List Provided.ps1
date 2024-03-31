# Define the computer name and the path to the user profiles
$computerName = "PC02.btnhd.edu"
$profilePath = "C:\Users"

# List of profiles to exclude from deletion
$profilesToExclude = @("bernardo.arocho", "btnhd", "Default", "Public")

# Get a list of all user profiles on the remote computer
$allProfiles = Get-WmiObject Win32_UserProfile -ComputerName $computerName | Where-Object { $_.Special -eq $false }

foreach ($profile in $allProfiles) {
    $userName = $profile.LocalPath.Split('\')[-1]

    # Check if the current profile should be excluded
    if ($profilesToExclude -notcontains $userName) {
        # Delete the user profile
        Write-Host "Deleting profile for $userName"
        Remove-Item -Path "$profilePath\$userName" -Force -Recurse
    } else {
        Write-Host "Excluding profile for $userName from deletion"
    }
}
