@echo off
setlocal enabledelayedexpansion

:: Read current version from serlzo.php (line with "Version:")
for /f "tokens=2 delims=:" %%i in ('findstr /i "Version:" serlzo.php') do set current=%%i
set current=%current: =%

:: Strip non-numeric/period chars
for /f "tokens=* delims= " %%i in ("%current%") do set current=%%i

echo Current version: %current%
set /p version=Enter new version (Press Enter to auto-increment): 

:: Auto-increment patch version if user pressed Enter
if "%version%"=="" (
    for /f "tokens=1,2 delims=." %%a in ("%current%") do (
        set major=%%a
        set minor=%%b
    )
    if "%minor%"=="" set minor=0
    set /a minor+=1
    set version=%major%.%minor%
)

echo New version: %version%

:: Update serlzo.php version line (only replace the Version: line)
powershell -Command "(Get-Content serlzo.php) -replace 'Version:\s*[0-9\.]+', 'Version: %version%' | Set-Content serlzo.php"

:: Create downloads folder if not exists
if not exist downloads mkdir downloads

:: Create zip file
echo Creating zip: serlzo-%version%.zip
powershell -Command "Compress-Archive -Path * -DestinationPath downloads\serlzo-%version%.zip -Force"

:: Generate checksum
echo Generating checksum...
for /f "tokens=1,2" %%i in ('certutil -hashfile downloads\serlzo-%version%.zip SHA256 ^| find /i /v "SHA256" ^| find /i /v "certutil"') do set checksum=%%i

echo SHA256: %checksum%

:: Update serlzo-wp.json with new version and checksum
powershell -Command "(Get-Content serlzo-wp.json) -replace '\"version\":\s*\"[0-9\.]+\"', '\"version\": \"%version%\"' -replace '\"download_checksum\":\s*\"sha256:[a-fA-F0-9]+\"', '\"download_checksum\": \"sha256:%checksum%\"' -replace '\"version\":\s*\"[0-9\.]+\"', '\"version\": \"%version%\"' | Set-Content serlzo-wp.json"

echo.
echo ✅ Done! Please upload downloads\serlzo-%version%.zip and serlzo-wp.json to your server.
pause
