@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off

takeown /f "%ProgramData%\Microsoft\Windows\SystemData" /a /r /d y

set ScreenPath=%ProgramData%\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z
set WallpaperPath=%AppData%\Microsoft\Windows\Themes\CachedFiles

del "%ScreenPath%\LockScreen_*"

setlocal EnableDelayedExpansion
for %%i in ("%WallpaperPath%\CachedImage_*") do (
	for /f "delims=_ tokens=2,3" %%j in ("%%~ni") do (
		set width=0000%%j
		set height=0000%%k
	)
	mklink "%ScreenPath%\LockScreen___!width:~-4!_!height:~-4!_notdimmed.jpg" "%%i"
)
endlocal
