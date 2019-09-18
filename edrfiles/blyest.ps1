$Global:dat=@()

Function Get-Blacklist(
$ipaddress)
{
$DNSBL = @("access.redhawk.org",
"all.s5h.net",
"b.barracudacentral.org",
"bl.spamcannibal.org",
"bl.spamcop.net",
"bl.tiopan.com",
"blackholes.wirehub.net",
"blacklist.sci.kun.nl",
"block.dnsbl.sorbs.net",
"blocked.hilli.dk",
"bogons.cymru.com",
"dnsbl.spfbl.net",
"cbl.abuseat.org",
"cblless.anti-spam.org.cn",
"dev.null.dk",
"dialup.blacklist.jippg.org",
"dialups.mail-abuse.org",
"dialups.visi.com",
"dnsbl.abuse.ch",
"dnsbl.anticaptcha.net",
"dnsbl.antispam.or.id",
"dnsbl.dronebl.org",
"dnsbl.justspam.org",
"dnsbl.kempt.net",
"dnsbl.sorbs.net",
"dnsbl.tornevall.org",
"dnsbl-1.uceprotect.net",
"duinv.aupads.org",
"dnsbl-2.uceprotect.net",
"dnsbl-3.uceprotect.net",
"dul.dnsbl.sorbs.net",
"escalations.dnsbl.sorbs.net",
"hil.habeas.com",
"black.junkemailfilter.com",
"http.dnsbl.sorbs.net",
"intruders.docs.uu.se",
"ips.backscatterer.org",
"korea.services.net",
"mail-abuse.blacklist.jippg.org",
"misc.dnsbl.sorbs.net",
"msgid.bl.gweep.ca",
"new.dnsbl.sorbs.net",
"no-more-funn.moensted.dk",
"old.dnsbl.sorbs.net",
"opm.tornevall.org",
"pbl.spamhaus.org",
"proxy.bl.gweep.ca",
"psbl.surriel.com",
"pss.spambusters.org.ar",
"rbl.schulte.org",
"rbl.snark.net",
"recent.dnsbl.sorbs.net",
"relays.bl.gweep.ca",
"relays.mail-abuse.org",
"relays.nether.net",
"rsbl.aupads.org",
"sbl.spamhaus.org",
"smtp.dnsbl.sorbs.net",
"socks.dnsbl.sorbs.net",
"spam.dnsbl.sorbs.net",
"spam.olsentech.net",
"spamguard.leadmon.net",
"spamsources.fabel.dk",
"exitnodes.tor.dnsbl.sectoor.de",
"ubl.unsubscore.com",
"web.dnsbl.sorbs.net",
"xbl.spamhaus.org",
"zen.spamhaus.org",
"zombie.dnsbl.sorbs.net",
"dnsbl.inps.de",
"bl.mailspike.net"
,"dnsbl.spfbl.net",
"noptr.spamrats.com")
$Results = @()
$rip = ($ipaddress -split "\.")[3..0] -join "."
$Postive = 0
$DNSBL | %{
$BLDomain = $_
       Write-Host "$rip.$_"
       $Global:dat+=Resolve-DnsName -Name "$rip.$_" -Type A
       Resolve-DnsName -Name "$rip.$_" -Type A -ErrorAction SilentlyContinue | %{
       Write-Host $_
       $Postive = $Postive++
       $Results += [pscustomobject]@{
       $BLDomain23 = "Detected: $true
                    Details: $((Resolve-DnsName -Name "$rip.$BLDomain" -Type TXT).Strings)
                    "
       }
       }
    write-host $Results
    }
    return [PSCustomObject]@{
    Total = $DNSBL.Count
    Postive = $Postive
    Scans = $Results
    }
}



<#


"213.251.182.115
195.154.250.216
195.154.243.31
195.154.241.119
220.174.209.154
195.154.240.176
91.208.99.2
213.251.182.111
195.154.251.120
195.154.240.246
213.251.182.114
85.25.103.119
188.138.9.49
185.129.148.203
176.126.252.11
91.207.7.54
46.165.230.5
5.79.68.161
88.80.196.2
77.247.181.162
46.118.156.191
210.210.178.20
114.104.158.172
89.31.57.5
60.166.48.158
219.148.39.134
60.12.119.200
77.247.181.163
92.63.87.97
61.185.139.72
61.37.150.6
60.174.192.240
61.150.76.201
213.251.182.103
37.130.227.133
94.242.246.23
221.130.130.238
218.107.46.228
222.92.204.50
118.144.83.130
218.22.187.66
91.109.247.173
173.208.177.59
222.191.233.238
35.0.127.52
1.234.83.77
183.65.17.118
194.150.168.95
218.29.52.2
58.244.173.130
207.244.70.35" -split "`r`n" | % {
$alldata=Get-Blacklist -ipaddress $_
$alldata
}
#>


$alldata=Get-Blacklist -ipaddress "127.9.1.2"


cbl.abuseat.org
No blacklisting for 127.9.1.2 found in dnsbl.sorbs.net
No blacklisting for 127.9.1.2 found in bl.spamcop.net
No blacklisting for 127.9.1.2 found in zen.spamhaus.org
No blacklisting for 127.9.1.2 found in b.barracudacentral.org
No blacklisting for 127.9.1.2 found in bad.psky.me