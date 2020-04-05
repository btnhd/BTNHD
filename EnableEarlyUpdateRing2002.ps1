
<#
.SYNOPSIS
    Enable fast ring for 2002 update package in ConfigMgr Current Branch.

.DESCRIPTION
    This script will allow you to enable fast UpdateRing in ConfigMgr Current Branch.

.PARAMETER SiteServer
    Top level site server name or IP address.
#>
Param (
    [Parameter(Mandatory=$True,Position=0, ParameterSetName="SiteServer Name or IP address", HelpMessage="Top level site server name or IP address.")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Connection -ComputerName $_ -Count 1 -Quiet})]
    [string]$siteServer
)


$WmiObjectSiteClass = "SMS_SCI_SiteDefinition"
$WmiObjectClass = "SMS_SCI_Component"
$WmiComponentName = "ComponentName='SMS_DMP_DOWNLOADER'"
$WmiComponentNameUpdateRing = "UpdateRing" 
$UpdateRingValue = 200253


# Determine SiteCode from WMI
# Get provider instance
try{
    Write-Host -Message "Determine the providers on the siteServer: '$($siteServer)'"
    $providerMachine = Get-WmiObject -namespace "root\sms" -class "SMS_ProviderLocation" -computername $siteServer

    # Get the first provider if there are multiple
    if($providerMachine -is [system.array])
    {
        $providerMachine=$providerMachine[0]
    }
    
    $SiteCode = $providerMachine.SiteCode
    $ProviderMachineName = $providerMachine.Machine
    $WmiObjectNameSpace="root\SMS\site_$($SiteCode)"

    Write-Host -Message "SiteCode: '$($SiteCode)'" 
    Write-Host -Message "Provider Machine Name: '$($ProviderMachineName)'" 

    # Get top level site sitecode
    $SiteDefinition = Get-WmiObject -Namespace $WmiObjectNameSpace -ComputerName $ProviderMachineName -Class $WmiObjectSiteClass | Where-Object { $_.ParentSiteCode -eq "" } 
    if(!($SiteCode  -eq $SiteDefinition.SiteCode) )
    {
        Write-Error -Message "Please provide the top level site IP or siteserver name." 
        return;
    }
}
catch [System.UnauthorizedAccessException] {
    Write-Warning -Message "Access denied" ; break
}
catch [System.Exception] {
    Write-Warning -Message "Unable to determine Site Code" ; break
}
                            

#Get component
$WmiObject = Get-WmiObject -Namespace $WmiObjectNameSpace -ComputerName $ProviderMachineName -Class $WmiObjectClass -Filter $WmiComponentName| Where-Object { $_.SiteCode -eq $SiteCode }

#Get embedded property
$props = $WmiObject.Props
$props = $props | where {$_.PropertyName -eq $WmiComponentNameUpdateRing}


if (!$props) {

    #Create embedded property
    $EmbeddedProperty = ([WMICLASS]"\\$($ProviderMachineName)\root\SMS\site_$($SiteCode):SMS_EmbeddedProperty").CreateInstance()
    $EmbeddedProperty.PropertyName = $WmiComponentNameUpdateRing
    $EmbeddedProperty.Value = $UpdateRingValue 
    $EmbeddedProperty.Value1 = ""
    $EmbeddedProperty.Value2 = ""

    $WmiObject.Props += [System.Management.ManagementBaseObject] $EmbeddedProperty

    $WmiObject.put()
}
else
{
    $props = $WmiObject.Props
    $index = 0
    ForEach($oProp in $props)
    {
        if($oProp.PropertyName -eq $WmiComponentNameUpdateRing)
        {
            $oProp.Value=$UpdateRingValue 
            $props[$index]=$oProp;
        }
        $index++
    }

    $WmiObject.Props = $props
    $WmiObject.put()
}


Write-Host "The command(s) completed successfully"
