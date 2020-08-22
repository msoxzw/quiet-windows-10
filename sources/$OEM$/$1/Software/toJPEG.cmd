@echo off

REM qscale = quality < 50 ? 5000 / quality : 200 - quality * 2

for %%i in (%*) do (
	ffmpeg -v 0 -i - -c bmp -f image2 - < %%i | cjpeg -quality 92,84 -optimize -sample 1x1 > "%%~dpni[baseline].jpg"
)
pause
