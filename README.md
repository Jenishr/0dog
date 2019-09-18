# Open0dog!
I have created the basic Network based Endpoint Dectection and Response Tool. Which can identify the process connected to malicious or blacklisted IP and it will notify and create a firewall rule for the process,ip and port.

Implimentation methode:

install sysmon with the specified configuration. Need to add event trigger on event id  3 sysmon event. to trigger the edr\edrfiles\test.ps1. then from that script start process. 
