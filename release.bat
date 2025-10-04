@echo off
setlocal

:: ==========================
:: CONFIGURATION
:: ==========================
set PLUGIN_NAME=serlzo
set REMOTE_HOST=145.14.152.127
set REMOTE_USER=u767822519.spellahub.com
set REMOTE_PASS=EOdan23#
set REMOTE_PATH=/serlzo/downloads
set JSON_FILE=serlzo-wp.json
set DOWNLOAD_URL=https://serlzo.spellahub.com/downloads

:: ==========================
:: ASK VERSION
:: ==========================
set /p VERSION=Enter new version (e.g. 1.1): 

:: ==========================
:: PREPARE DIRECTORIES
:: ==========================
if not exist downloads mkdir downloads

set ZIPFILE=%PLUGIN_NAME%-%VERSION%.zip
set ZIPPATH=downloads\%ZIPFILE%

:: ==========================
:: UPDATE serlzo.php VERSION
:: ==========================
echo Updating version in serlzo.php to %VERSION% ...
powershell -Command "(Get-Content serlzo.php) -replace 'Version: .*', 'Version: %VERSION%' | Set-Content serlzo.php"

:: ==========================
:: CREATE ZIP
:: ==========================
echo Creating zip: %ZIPFILE% ...
if exist "%ZIPPATH%" (
  echo Deleting old zip...
  del /f /q "%ZIPPATH%"
)

powershell -Command "if(Test-Path '%ZIPPATH%'){Remove-Item '%ZIPPATH%' -Force}; Compress-Archive -Path * -DestinationPath '%ZIPPATH%' -Force"

:: ==========================
:: GENERATE CHECKSUM
:: ==========================
echo Generating checksum...
for /f "tokens=1,*" %%a in ('CertUtil -hashfile "%ZIPPATH%" SHA256 ^| findstr /v "hash"') do set CHECKSUM=%%a

echo SHA256: %CHECKSUM%

:: ==========================
:: UPDATE JSON FILE
:: ==========================
echo Updating %JSON_FILE% ...

(
echo {
echo   "version": "%VERSION%",
echo   "download_url": "%DOWNLOAD_URL%/%ZIPFILE%",
echo   "download_checksum": "sha256:%CHECKSUM%",
echo   "requires": "6.0",
echo   "tested": "6.5",
echo   "sections": {
echo     "changelog": "<h4>%VERSION%</h4><ul><li>Bug fixes</li><li>Improvements</li></ul>",
echo     "description": "<h4>Serlzo Dashboard</h4><p>Displays the Serlzo HTML/CSS dashboard inside WP admin.</p>"
echo   }
echo }
) > %JSON_FILE%

:: ==========================
:: UPLOAD TO HOSTINGER
:: ==========================
echo Uploading files to server...

:: Upload ZIP
curl -T "%ZIPPATH%" -u %REMOTE_USER%:%REMOTE_PASS% ftp://%REMOTE_HOST%%REMOTE_PATH%/%ZIPFILE%

:: Upload JSON
curl -T "%JSON_FILE%" -u %REMOTE_USER%:%REMOTE_PASS% ftp://%REMOTE_HOST%/serlzo/%JSON_FILE%

echo.
echo ===========================================
echo Done! Version %VERSION% released.
echo Zip File: %DOWNLOAD_URL%/%ZIPFILE%
echo Manifest: https://serlzo.spellahub.com/%JSON_FILE%
echo ===========================================

pause
