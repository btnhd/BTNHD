New-VMSwitch -SwitchName "NAT-Switch" -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.200.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NAT-Switch)"
New-NetNat -Name "NAT-Network" -InternalIPInterfaceAddressPrefix 192.168.200.0/24