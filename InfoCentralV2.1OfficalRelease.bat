@echo off
title INFO CENTRAL v2.1
color 0A
setlocal enabledelayedexpansion
cls

echo =========================================
echo            INFO CENTRAL v2.1
echo =========================================
echo Type HELP to list commands.
echo Type HELP command for details.
echo.

:main
set cmd=
set arg=
set /p input=central@user:~$ 

for /f "tokens=1,2" %%A in ("%input%") do (
    set cmd=%%A
    set arg=%%B
)

if /i "%cmd%"=="help" goto help
if /i "%cmd%"=="sysinfo" goto sysinfo
if /i "%cmd%"=="whoami" goto whoami
if /i "%cmd%"=="uptime" goto uptime
if /i "%cmd%"=="localip" goto localip
if /i "%cmd%"=="publicip" goto publicip
if /i "%cmd%"=="geoip" goto geoip
if /i "%cmd%"=="pingtest" goto pingtest
if /i "%cmd%"=="trace" goto trace
if /i "%cmd%"=="processes" goto processes
if /i "%cmd%"=="memory" goto memory
if /i "%cmd%"=="cpu" goto cpu
if /i "%cmd%"=="netstat" goto netstatcmd
if /i "%cmd%"=="wifi" goto wifi
if /i "%cmd%"=="battery" goto battery
if /i "%cmd%"=="drivers" goto drivers
if /i "%cmd%"=="gpu" goto gpu
if /i "%cmd%"=="time" goto timecmd
if /i "%cmd%"=="admin" goto admin
if /i "%cmd%"=="clear" cls & goto main
if /i "%cmd%"=="exit" exit

echo Unknown command. Type HELP.
goto main

:: ================= HELP SYSTEM =================

:help
if "%arg%"=="" (
    echo.
    echo Available Commands:
    echo -------------------
    echo sysinfo
    echo whoami
    echo uptime
    echo localip
    echo publicip
    echo geoip
    echo pingtest
    echo trace
    echo processes
    echo memory
    echo cpu
    echo netstat
    echo wifi
    echo battery
    echo drivers
    echo gpu
    echo time
    echo admin
    echo clear
    echo exit
    echo.
    echo Use: HELP command
    echo Example: HELP drivers
    echo.
    goto main
)

if /i "%arg%"=="drivers" (
    echo DRIVERS
    echo Lists currently loaded Windows system drivers.
    goto main
)

if /i "%arg%"=="gpu" (
    echo GPU
    echo Displays detected graphics processors.
    goto main
)

echo No detailed help available for "%arg%".
goto main

:: ================= COMMANDS =================

:sysinfo
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
goto main

:whoami
echo User: %USERNAME%
echo Computer: %COMPUTERNAME%
goto main

:uptime
net statistics workstation | find "Statistics since"
goto main

:localip
ipconfig | findstr IPv4
goto main

:publicip
powershell -NoProfile -Command "Invoke-RestMethod 'https://api.ipify.org'"
goto main

:geoip
set /p gip=Enter IP to locate: 
powershell -NoProfile -Command ^
"$r=Invoke-RestMethod 'http://ip-api.com/json/%gip%'; ^
Write-Host 'IP:' $r.query; ^
Write-Host 'Country:' $r.country; ^
Write-Host 'Region:' $r.regionName; ^
Write-Host 'City:' $r.city; ^
Write-Host 'ISP:' $r.isp"
goto main

:pingtest
set /p tgt=Enter target to ping: 
ping %tgt%
goto main

:trace
set /p tgt=Enter target for traceroute: 
tracert %tgt%
goto main

:processes
tasklist
goto main

:memory
powershell -NoProfile -Command ^
"$m=Get-CimInstance Win32_OperatingSystem; ^
Write-Host 'Total RAM:' ([math]::Round($m.TotalVisibleMemorySize/1MB,2)) 'GB'; ^
Write-Host 'Free RAM:' ([math]::Round($m.FreePhysicalMemory/1MB,2)) 'GB'"
goto main

:cpu
powershell -NoProfile -Command ^
"$c=Get-CimInstance Win32_Processor; ^
Write-Host 'CPU:' $c.Name; ^
Write-Host 'Load:' $c.LoadPercentage '%'"
goto main

:netstatcmd
netstat -ano
goto main

:wifi
netsh wlan show interfaces
goto main

:battery
powershell -NoProfile -Command ^
"$b=Get-CimInstance Win32_Battery; ^
if ($null -eq $b) { ^
Write-Host 'No battery detected.' } else { ^
Write-Host 'Charge:' $b.EstimatedChargeRemaining '%'; ^
Write-Host 'Status:' $b.BatteryStatus }"
goto main

:drivers
driverquery
goto main

:gpu
powershell -NoProfile -Command ^
"$g=Get-CimInstance Win32_VideoController; ^
foreach ($i in $g) {Write-Host 'GPU:' $i.Name}"
goto main

:timecmd
echo %DATE% %TIME%
goto main

:admin
net session >nul 2>&1
if %errorlevel%==0 (
    echo Admin privileges: YES
) else (
    echo Admin privileges: NO
)
goto main
