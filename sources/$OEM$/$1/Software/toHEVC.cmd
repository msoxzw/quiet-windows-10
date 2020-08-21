@echo off

REM qp = 12.0 + 6.0 * log2(qscale / 0.85)
REM qscale = 0.85 * pow(2.0, (qp - 12.0) / 6.0)

for %%i in (%*) do (
	REM H.264
	REM ffmpeg -i - -map 0 -c copy -c:v libx264 -preset slower -crf 19.4 -x264-params ref=5:subme=10:fast-pskip=0:threads=%NUMBER_OF_PROCESSORS%:lookahead-threads=1 -c:a libopus -f matroska - < %%i > "%%~dpni[AVC_Opus].mkv"
	REM H.265
	ffmpeg -i - -map 0 -c copy -c:v libx265 -preset slower -crf 19.4 -x265-params limit-refs=3:max-merge=5:subme=5:pools=%NUMBER_OF_PROCESSORS%:frame-threads=1 -c:a libopus -f matroska - < %%i > "%%~dpni[HEVC_Opus].mkv"
)
pause
