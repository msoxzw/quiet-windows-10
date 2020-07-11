@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

for /d %%i in (*) do (
	for /f "tokens=3*" %%j in ('reg query "HKLM\Software\Mozilla\Mozilla %%~ni" /v "Install Directory" /s ^| find "REG_SZ"') do (
		robocopy "%%i" "%%k" /s
	)
)

popd
