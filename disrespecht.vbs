' disrespecht.vbs
' 11/18/2014 by monkeysnotmsp@gmail.com
' For Derpy State Community College
' Sets network adapters to DHCP

Option Explicit
On Error Resume Next

strComputer = "."
Set objShell = WScript.CreateObject("WScript.Shell")
arrDNSSuffixes = Array("")
Const FULL_DNS_REGISTRATION = True
Const DOMAIN_DNS_REGISTRATION = False

' Remove FQDN Suffix
objshell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\NV Domain","","REG_SZ" 

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colNetAdapters = objWMIService.ExecQuery ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")

For Each objNetAdapter in colNetAdapters
objNetAdapter.EnableDHCP()
objNetAdapter.SetDNSServerSearchOrder()
objNetAdapter.SetDynamicDNSRegistration FULL_DNS_REGISTRATION, DOMAIN_DNS_REGISTRATION
objNetAdapter.SetDNSDomain()

Set objNetworkSettings = objWMIService.Get("Win32_NetworkAdapterConfiguration")
objNetworkSettings.SetDNSSuffixSearchOrder(arrDNSSuffixes)

Next

' Bounce the box
objShell.Run ("Shutdown -r -t 0")



