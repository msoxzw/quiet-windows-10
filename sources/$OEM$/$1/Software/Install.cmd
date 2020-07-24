@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

if not defined ChocolateyInstall (
	set chocolateyUseWindowsCompression=true
	PowerShell -ExecutionPolicy Bypass -Command "Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression; Start-Process cmd '/c \"\"%~f0\" %*\"'"
	exit /b
)

set apps=7zip adobereader aria2 ccleaner.portable ffmpeg firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent stubby thunderbird

:install
"%ChocolateyInstall%\choco.exe" install %apps% -y || (timeout /t 60 & goto install)

REM Associate archive formats with 7-Zip with the system default icon
for /f "tokens=2*" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip /v DisplayIcon') do ( 
	for %%k in (001 7z arj bz2 bzip2 cpio deb gz gzip lha lzh lzma rar rpm tar taz tbz tbz2 tgz tpz txz xz z zip) do (
		reg add HKCR\.%%k /d 7-Zip.%%k /f
		reg add HKCR\7-Zip.%%k /d "%%k Archive" /f
		reg add HKCR\7-Zip.%%k\shell\open\command /d "\"%%j\" \"%%1\"" /f
		reg copy HKCR\CompressedFolder\DefaultIcon HKCR\7-Zip.%%k\DefaultIcon /f
	)
)

REM Configure CCleaner Portable
(
	echo [Options]
	PowerShell "$CCleaner=Get-Item HKCU:\Software\Piriform\CCleaner; $CCleaner.GetValueNames() | % {Write-Output $_=$($CCleaner.GetValue($_))}"
) > "%ChocolateyInstall%\lib\ccleaner.portable\tools\ccleaner.ini"

REM Copy regional and language settings to all users and also the system account (logonUI screen)
control intl.cpl,,/f:"Language.xml"
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /va /f

REM Download and install the latest Source Han Super OTC
REM Change the default fonts for Chinese, Japanese, and Korean (CJK) languages to Source Han
call Fonts\setup.cmd

REM Generate JetBrains products silent download and install batch files
call JetBrains\setup.cmd

REM Set desktop backgroud as the default lock screen image without changing any setting
REM Require turning off all suggestions
call LockScreen.cmd

REM Configure Chromium based browsers
call Chromium\setup.cmd

REM Configure Firefox and Thunderbird with the custom install directory
call Mozilla\setup.cmd


for %%i in (Tasks\*.xml) do schtasks /create /tn "%%~ni" /xml "%%i" /f

REM Set local DNS server addresses only if any of them are operational.
PowerShell "if (Resolve-DnsName example.com -Server localhost) {Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses (Resolve-DnsName localhost).IPAddress}"

schtasks /change /tn Install /disable

popd
