$Year = 2020
$Path = 'C:\BTNHD'

$Date = Get-Date -Year $Year -Month 1 -Day 1

While ($Date.Year -eq $Year) {
    $NewFolder = '{0}\{1}\{2}-{1}\{2}-{3}-{1}' -f (
        $Path,
        $Date.ToString('yyyy'),
        $Date.ToString('MM'),
        $Date.ToString('dd')
    )

    "Creating folder $NewFolder"
    $null = New-Item -Type Directory -Path $NewFolder -ErrorAction SilentlyContinue

    $Date = $Date.AddDays(1)
}