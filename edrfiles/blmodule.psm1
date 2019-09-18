$Global:datas=@()
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ # Powershell script
	$presentpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else
{ # PS2EXE compiled script
	$presentpath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
}
Function IPreverse($ip){
$ipParts = $ip.Split('.')
[array]::Reverse($ipParts)
$ipParts = [string]::Join('.', $ipParts)
Write-Output $ipParts

}



<#
SBL	sbl.spamhaus.org	127.0.0.2-3,8-9	Static UBE sources, verified spam services (hosting or support) and ROKSO spammers
XBL	xbl.spamhaus.org	127.0.0.4-7	Illegal 3rd party exploits, including proxies, worms and trojan exploits
PBL	pbl.spamhaus.org	127.0.0.10-11	IP ranges which should not be delivering unauthenticated SMTP email.
ZEN	zen.spamhaus.org	127.0.0.2-11	Combined zone (recommended)
Includes SBL, XBL and PBL.
#>

Function bldetails($bldata){
Switch -regex ($bldata)
{

"127\.0\.0\.([2-3]|[8-9])"{
$bexpand=[pscustomobject]@{
    btype="SBL"
    bdomain="sbl.spamhaus.org"
    bdetails="127.0.0.2-3,8-9	Static UBE sources, verified spam services (hosting or support) and ROKSO spammers"
    }
}

"127\.0\.0\.([4-7])" {
$bexpand=[pscustomobject]@{
    btype="XBL"
    bdomain="xbl.spamhaus.org"
    bdetails="127.0.0.4-7	Illegal 3rd party exploits, including proxies, worms and trojan exploits"
    }
}

"127\.0\.0\.([10-11])"{
$bexpand=[pscustomobject]@{
    btype="PBL"
    bdomain="pbl.spamhaus.org"
    bdetails="IP ranges which should not be delivering unauthenticated SMTP email"
    }
}


Default {$bexpand="didn't match anything..." }
}

return $bexpand
}







Function ipblcheck($IP){
$blacklists=@("cbl.abuseat.org","dnsbl.sorbs.net","bl.spamcop.net","zen.spamhaus.org","b.barracudacentral.org","access.redhawk.org","all.s5h.net","b.barracudacentral.org","bl.spamcannibal.org","bl.spamcop.net","bl.tiopan.com","blackholes.wirehub.net","blacklist.sci.kun.nl","block.dnsbl.sorbs.net","blocked.hilli.dk","bogons.cymru.com","dnsbl.spfbl.net","cbl.abuseat.org","cblless.anti-spam.org.cn","dev.null.dk","dialup.blacklist.jippg.org","dialups.mail-abuse.org","dialups.visi.com","dnsbl.abuse.ch","dnsbl.anticaptcha.net","dnsbl.antispam.or.id","dnsbl.dronebl.org","dnsbl.justspam.org","dnsbl.kempt.net","dnsbl.sorbs.net","dnsbl.tornevall.org","dnsbl-1.uceprotect.net","duinv.aupads.org","dnsbl-2.uceprotect.net","dnsbl-3.uceprotect.net","dul.dnsbl.sorbs.net","escalations.dnsbl.sorbs.net","hil.habeas.com","black.junkemailfilter.com","http.dnsbl.sorbs.net","intruders.docs.uu.se","ips.backscatterer.org","korea.services.net","mail-abuse.blacklist.jippg.org","misc.dnsbl.sorbs.net","msgid.bl.gweep.ca","new.dnsbl.sorbs.net","no-more-funn.moensted.dk","old.dnsbl.sorbs.net","opm.tornevall.org","pbl.spamhaus.org","proxy.bl.gweep.ca","psbl.surriel.com","pss.spambusters.org.ar","rbl.schulte.org","rbl.snark.net","recent.dnsbl.sorbs.net","relays.bl.gweep.ca","relays.mail-abuse.org","relays.nether.net","rsbl.aupads.org","sbl.spamhaus.org","smtp.dnsbl.sorbs.net","socks.dnsbl.sorbs.net","spam.dnsbl.sorbs.net","spam.olsentech.net","spamguard.leadmon.net","spamsources.fabel.dk","exitnodes.tor.dnsbl.sectoor.de","ubl.unsubscore.com","web.dnsbl.sorbs.net","xbl.spamhaus.org","zen.spamhaus.org","zombie.dnsbl.sorbs.net","dnsbl.inps.de","bl.mailspike.net","dnsbl.spfbl.net","noptr.spamrats.com")
$revip=IPreverse -ip $IP
$count=0
foreach ( $blacklist in $blacklists ) {
	if ( $blacklist -contains "dnsbl.httpbl.org" ) {
		# Add your httpBL API-key from Project Honey Pot
		$lookupAddress = $httpBL + "." + $revip + ".dnsbl.httpbl.org."
	}
	else {
		$lookupAddress = $revip + ".$blacklist."
	}
	try {
		$Global:datas+=[System.Net.Dns]::GetHostEntry($lookupAddress)
        
# | select-object HostName,AddressList
        $count=$count+1
	}
	catch {
		# The try{} catch{} is needed to catch DNS lookup 
		# errors when an IP address is not blacklisted.
		# Yes, this is annoying
        #$_ >> $presentpath\error.log
        $null=$_
        
	}
}

$bscandetails=@()
$Global:datas | % {
$bscandetails+=bldetails -bldata $($_.AddressList.IPAddressTOString)
}


return [PSCustomObject]@{
    Total = $blacklists.Count
    Postive = $count
    Scans = $bscandetails
    IP=$IP
    reverse=$revip
    }

Write-Output [PSCustomObject]@{
    Total = $blacklists.Count
    Postive = $count
    Scans = $bscandetails
    IP=$IP
    reverse=$revip
    }
}



Export-ModuleMember -Function ipblcheck

Export-ModuleMember -Function IPreverse


ipblcheck -IP 103.5.135.102