::	Script start...
::	@echo off
::	Change Directory to the script's one, since windows will execute at "\windows\system32" when chosen to run as administrator...
::  V1.0-LDE-Live Windows Forensic Data Extraction Tool
::  By Jetty Sairam
::  A script to extract data required to perform forensic analysis from a Live Windows Machine
cd /d "%~d0%~p0"

::Get Date and Time
For /F "tokens=1,2,3,4 delims=/ " %%A in ('Date /t') do @( 
Set FullDate="%%D-%%C-%%B"
)

For /F "tokens=1,2,3 delims=: " %%A in ('time /t') do @( 
Set FullTime="%%A-%%B"
)

set dirname="%computername%_%FullDate%_%FullTime%"
mkdir "%dirname%"
cd "%dirname%"
set var=%computername%.txt

type ..\commands.txt >> %var%

for /f "tokens=*" %%a in (..\commands.txt) do @(
echo. >> %var%
echo. >> %var%
echo ======================================== >> %var%
echo ======================================== >> %var%
echo %%a >> %var%
echo ======================================== >> %var%
echo ======================================== >> %var%
cmd /c "%%a" >> %var%
)
cd ..
cd _Tools
autorunsc.exe -a -f -c >> ..\%dirname%\autoruns.csv
handle.exe -a -u >> ..\%dirname%\handles.txt
HiJackThis.EXE /silentautolog
move hijackthis.log ..\%dirname%\
listdlls.exe >> ..\%dirname%\dlls.txt
psinfo -s -h -d >> ..\%dirname%\psinfo.txt
pslist -t >> ..\%dirname%\pslist.txt
psgetsid >> ..\%dirname%\psgetsid.txt
psloggedon.exe >> ..\%dirname%\psloggedon.txt
Tcpvcon.exe -a -c -n >> ..\%dirname%\tcpvcon.txt
echo +++++System Information: Time Zone, Installed Software, OS Version, Uptime, File System+++++ >> ..\%dirname%\Sysinfo.txt
systeminfo >> ..\%dirname%\Sysinfo.txt
echo +++++User Accounts+++++ >> ..\%dirname%\User_accounts.txt
net user >> ..\%dirname%\User_accounts.txt
echo +++++Groups+++++ >> ..\%dirname%\User_Groups.txt
net localgroup >> ..\%dirname%\User_Groups.txt
echo +++++Network Interfaces+++++ >> ..\%dirname%\Network_Interfaces.txt
ipconfig /all >> ..\%dirname%\Network_Interfaces.txt
echo +++++Routing Table+++++ >> ..\%dirname%\Routing_Table.txt
route print >> ..\%dirname%\Routing_Table.txt
echo +++++ARP Table+++++ >> ..\%dirname%\ARP_Table.txt
arp -a >> ..\%dirname%\ARP_Table.txt
echo +++++DNS Cache+++++ >> ..\%dirname%\DNS_Cache.txt
ipconfig /displaydns >> ..\%dirname%\DNS_Cache.txt
echo +++++Network Connections+++++ >> ..\%dirname%\Network_Connections.txt
netstat -abn >> ..\%dirname%\Network_Connections.txt
