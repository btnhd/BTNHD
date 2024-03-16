<# 
.DESCRIPTION 
	
.NOTES 
    File Name  : Creating QR Codes for Wireless Network
    Author     : Bernardo (BNTHD)
.LINK 

#> 
Install-Module -Name QRCodeGenerator

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

Import-Module QRCodeGenerator

Get-Command -Module QRCodeGenerator

New-QRCodeWifiAccess -SSID 'BTNHD GUEST' -Password 'P@55w0rd!' -Width 15 -OutPath 'C:\BTNHD_TEMP\WIFI.PNG'

$WIRELESS_SSID = 'BTNHD WIFI'
$WIRELESS_PASSWORD = 'P@55w0rd!2024'
$DESTINATION_FILE = 'C:\BTNHD_TEMP\WIFI2.PNG'
New-QRCodeWifiAccess -SSID $WIRELESS_SSID -Password $WIRELESS_PASSWORD -Width 15 -OutPath $DESTINATION_FILE