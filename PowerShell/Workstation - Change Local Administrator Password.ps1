$computers = Get-Content "C:\BTNHD_TEMP\hosts.txt"
$password = Read-Host "Enter New Admin Password:" -assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Foreach ($computer in $computers) {
$IsOnline = "OFFLINE"
$status = "SUCCESS"
$statusError = "FAILED"
    
    if((Test-Connection -ComputerName $computer -Count 1 -ErrorAction 0))
    {
        $IsOnline = "ONLINE"
        } else { $statusError = "`t$computer is OFFLINE" }
    try 
    {
        $user = [adsi]"WinNT://$computer/Administrator" #change this to your local admin
        $user.SetPassword("$decodedpassword")
        $statusError = "Admin Password Changed Successfully!"

            }
    catch
    {
        $status = "FAILED"
        $statusError = "$_"
        }
$Report = New-Object -TypeName PSObject -Property @{ #create a hash-table
ComputerName = $computer
IsOnline = $IsOnline
PasswordChangeStatus = $status
DetailedStatus = $statusError
}

$Report | Select-Object ComputerName, IsOnline, PasswordChangeStatus, DetailedStatus | Export-Csv -Append -Path "C:\BTNHD_TEMP\LOCALPWDREPORT_04.06.2024.csv"
}
#send out email
$credential = Get-Credential #this is only if your SMTP need credential to send email

#create a hash-table
$mailReport = @{
    SmtpServer = 'smtp.mandrillapp.com' #enter your SMTP 
    Port = '587'
    UseSSL = $true 
    Credential = $credential
    From = 'LocalPCPWDReport@gmail.com'
    To = 'EnterYourEmailAddress@gmail.com'
    Subject = "Local Computer Password Status Report - $(Get-Date -Format g)"
    Body = 'Status report on changing local PC admin password'
	Attachments = 'C:\BTNHD_TEMP\LOCALPWDREPORT_04.06.2024.csv'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

Send-MailMessage @mailReport

