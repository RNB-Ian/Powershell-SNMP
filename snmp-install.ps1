##############################################################
# Description: Powershell script to install and configure SNMP
# Created By: Ian Hillier + Google
# Last update: 2019.11.21
##############################################################

#  If using them, Add community managers in format @("manager1","manager2")
# $pmanagers = @("snmpserver1.company.com","snmpserver2.company.com") 
# Add community string in format @("CommunityName"")
$CommString = @("TnWUy0T1lc") 

#Import ServerManger Module
Import-Module ServerManager

#Check if SNMP-Service is already installed
$check = Get-WindowsFeature -Name SNMP-Service

# Check for and install SNMP-Service
If ($check.Installed -ne "True") {
Write-Host "SNMP Service Installing..."
Install-WindowsFeature SNMP-Service | Out-Null
Install-WindowsFeature RSAT-SNMP | Out-Null
}
Else {
# Restart the SNMP Service
net stop snmp
net start snmp
}

# Remove localhost from SNMP security tab
reg delete HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers\ /v 1 /f

# Remove any existing community names
reg delete HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities /va /f

# Add the new community name
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $CommString /t REG_DWORD /d 4

# Restart the SNMP Service
net stop snmp
net start snmp