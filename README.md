#0dog

What is 0dog?
0dog is the PowerShell based malicious ip detection tool. I have planned for multiple phrase of this tool. The first level or first version of the tool I have added the DNSBL as a malicious or block list checker and Sysmon for generating event for process which trying to accesses the network.
Why this tool is for?
 As I mentioned earlier, this is first level of tool for detecting and blocking the malicious ip.  Many of the personal computers are mostly targeted with known malware which were trying to connect to known C&C servers.  My idea is to detect those and block them will reduce the amount of damage in personal environment.
What is DNSBL?
Domain Name System Blacklists, also known as DNSBL's or DNS Blacklists, are spam blocking lists that allow a website administrator to block messages from specific systems that have a history of sending spam. As their name implies, the lists are based on the Internet's Domain Name System, which converts complicated, numerical IP address such as 66.171.248.182 into domain names like example.net, making the lists much easier to read, use, and search. If the maintainer of a DNS Blacklist has in the past received spam of any kind from a specific domain name, that server would be "blacklisted" and all messages sent from it would be either flagged or rejected from all sites that use that specific list.
How the tool works?
Sysmon must install in all system with the configuration given in the https://github.com/Jenishr/Open0dog-/blob/master/edrfiles/Sysmon/sysmonedr.xml.
Need to add event trigger on event id 3 sysmon event. to trigger the edr\edrfiles\0dog.ps1.
Whenever event trigger the script which will parse the ip address and process name and match against the DNSBL list. If the ip is malicious or blacklisted, then it will trigger the notification and create custom rule in firewall.
