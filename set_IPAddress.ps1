#check the current IP address configuration 
Get-NetIPConfiguration

#get list of NIC adapters
Get-NetAdapter

#configure IP address to NIC adapter by using InterfaceIndex
New-NetIPAddress -InterfaceIndex 16 -IPAddress 192.168.200.12 -PrefixLength 24 -DefaultGateway 192.168.200.1

#configure DNS IP address to NIC adapter by using InterfaceIndex
Set-DnsClientServerAddress -InterfaceIndex 16 -ServerAddresses 192.168.200.10, 8.8.8.8