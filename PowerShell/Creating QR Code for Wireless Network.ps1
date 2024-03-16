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

New-QRCodeWifiAccess -SSID 'MYWIFI' -Password '123qwe' -Width 15 -OutPath 'C:\BTNHD_TEMP\WIFI.PNG'

$WIRELESS_SSID = 'MYWIFI'
$WIRELESS_PASSWORD = '123qwe'
$DESTINATION_FILE = 'C:\BTNHD_TEMP\WIFI.PNG'
New-QRCodeWifiAccess -SSID $WIRELESS_SSID -Password $WIRELESS_PASSWORD -Width 15 -OutPath $DESTINATION_FILE