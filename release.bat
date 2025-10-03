@echo off
setlocal

:: Ask for new version
set /p new_version=Enter new version (e.g. 1.1): 

echo.
echo === Updating serlzo.php version to %new_version% ===

:: Update the "Version:" line inside serlzo.php
powershell -Command "(Get-Content serlzo.php) -replace 'Version:\s*[0-9.]+', 'Version: %new_version%' | Set-Content serlzo.php"

echo.
echo === Creating zip: serlzo-%new_version%.zip ===

:: Delete old zip if it exists
if exist downloads\serlzo-%new_version%.zip del /f /q downloads\serlzo-%new_version%.zip

:: Create new zip of everything in this folder
powershell -Command "Compress-Archive -Path * -DestinationPath 'downloads/serlzo-%new_version%.zip' -Force"

echo.
echo === Generating checksum... ===
for /f "tokens=1,*" %%a in ('certutil -hashfile downloads\serlzo-%new_version%.zip SHA256 ^| find /i /v "hash" ^| find /i /v "certutil"') do set checksum=%%a
echo SHA256: %checksum%

echo.
echo === Updating serlzo-wp.json ===
powershell -Command "(Get-Content serlzo-wp.json) -replace '\"version\": \".*\"', '\"version\": \"%new_version%\"' -replace '\"download_url\": \".*\"', '\"download_url\": \"https://serlzo.spellahub.com/downloads/serlzo-%new_version%.zip\"' -replace '\"download_checksum\": \".*\"', '\"download_checksum\": \"sha256:%checksum%\"' | Set-Content serlzo-wp.json"

echo.
echo ✅ Done! Version bumped to %new_version%
echo Upload downloads\serlzo-%new_version%.zip and serlzo-wp.json to your server.
pause
