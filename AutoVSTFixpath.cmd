@echo off
:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
title Adding Registry keys....
REG ADD "HKLM\Software\VST" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files\\Common Files\\Audio Plug-ins\\VST2"
REG ADD "HKLM\Software\VST3" /v "VST3PluginsPath" /t REG_SZ /d "C:\\Program Files\\Common Files\\Audio Plug-ins\\VST3"
REG ADD "HKLM\Software\WOW6432Node\VST" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files (x86)\\Common Files\\Audio Plug-ins\\VST2"
REG ADD "HKLM\Software\WOW6432Node\VST3" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files (x86)\\Common Files\\Audio Plug-ins\\VST3"

mkdir "C:\Program Files\Common Files\Audio Plug-ins\VST2"
mkdir "C:\Program Files\\Common Files\Audio Plug-ins\VST3"
mkdir "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
mkdir "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST3" 

title Moving VST2 Path.....
echo Moving VST2 (64bit) to New location...
cd "C:\Program Files\VSTPlugins"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\Steinberg\VSTPlugins"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\Common Files\VST"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\VST"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
rem
echo Moving VST2 (32bit) to New location...
cd "C:\Program Files (x86)\VSTPlugins"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\Steinberg\VSTPlugins"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\Common Files\VST"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\VST"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"

title Moving VST3 Path.... 
echo Moving VST3 (64bit) to New location...
cd "C:\Program Files\Common Files\VST3"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST3"

echo Moving VST3 (32bit) to New location...
cd "C:\Program Files (x86)\Common Files\VST3"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST3"

echo done!!! 
pause
cls 
title Fixing in FL Studio
set /P c=Are you sure you want to fixing VSTPath on FL Studio[Y/N]?
if /I "%c%" EQU "Y" goto :somewhere
if /I "%c%" EQU "N" goto :somewhere_else

:somewhere
echo --------------------------------------
echo Fixing......
echo --------------------------------------
REG Add "HKLM\SOFTWARE\Image-Line\Shared\Paths" /v "VST Plugins" /t REG_SZ /d "C:\Program Files\Common Files\Audio Plug-ins\VST2"
echo Done!!
echo in Other DAW your can setting vstpath in preferences, Enjoy!
pause

:somewhere_else
echo in Other DAW your can setting vstpath in preferences, Enjoy!
pause
goto EOF

:EOF
exit
