if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ # Powershell script
	$presentpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else
{ # PS2EXE compiled script
	$presentpath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
}
$ErrorActionPreference = "SilentlyContinue" 




Import-Module $presentpath\blmodule.psm1

Import-Module $presentpath\notifier.psm1


Import-Module $presentpath\responser.psm1


$Global:notify_data=[pscustomobject]@{
Image=$null
User=$null
SourceAddress=$null
SourcePort=$null
DestinationIp=$null
DestinationPort=$null
}

#notifyme -ntdata $Global:notify_data

$Global:notify_data

#$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$args > $presentpath\args.txt
$utctime=$args[0]
$ProcessGuid=$args[1]
$ProcessId=$args[2]
$Image=$args[3]
$User=$args[4]
$Protocol=$args[5]
$SourceAddress=$args[6]
$SourceHostname=$args[7]
$SourcePort=$args[8]
$SourcePortName=$args[9]
$DestinationIp=$args[10]
$DestinationHostname=$args[11]
$DestinationPort=$args[12]
$DestinationPortName=$args[13]

$blc_result=ipblcheck -IP $DestinationIp

if($blc_result.Postive -ne 0){
$Global:notify_data.DestinationIp=$DestinationIp
$Global:notify_data.DestinationPort=$DestinationPort
$Global:notify_data.SourceAddress=$SourceAddress
$Global:notify_data.SourcePort=$SourcePort
$Global:notify_data.Image=Split-Path $Image -leaf
$Global:notify_data.User=$User
notifyme -ntdata $Global:notify_data
$cdate=Get-Date -Format "yyyymmddhhmmss"
$ruleid = $cdate+"_"+"$($notify_data.Image)"
Firewallblocker -sourceIP $SourceAddress -destinationIP $DestinationIp -dport $DestinationPort -sport $SourcePort -protocol $Protocol -direction "outbound" -image $Image -ruleid $ruleid
$blc_result > $presentpath\result.txt
}


$Error > $presentpath\error.log
