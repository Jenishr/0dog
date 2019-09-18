if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ # Powershell script
	$global:presentpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else
{ # PS2EXE compiled script
	$global:presentpath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
}


Function Firewallblocker{
Param($sourceIP,$destinationIP,$direction,$sport,$dport,$protocol,$image,$ruleid)
$cdate=get-date -Format "yyyymmddhhmmss"
try{
New-NetFirewallRule -DisplayName "0dog_fw_rule_$ruleid-$cdate" -Description "0dog! blocked $sourceIP $destinationIP $direction $sport $dport $protocol $image" -Direction $direction -RemotePort $dport -RemoteAddress $destinationIP -Protocol $protocol -Action Block -Enabled True -Program $image -AsJob |Out-Null 
}
catch{
$_ >> "$global:presentpath\fw_error.log"
}
}