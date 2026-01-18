@echo off
REM Darbeliai Release Zip Creator
REM Run this script from the eeglab-darbeliai folder

REM Read version directly using PowerShell (handles UTF-8 properly)
for /f "usebackq delims=" %%v in (`powershell -Command "(Get-Content 'Darbeliai.versija' -First 1) -replace 'Darbeliai v', ''"`) do set VERSION=%%v

if "%VERSION%"=="" (
    echo Error: Could not read version from Darbeliai.versija
    pause
    exit /b 1
)

set FOLDER_NAME=Darbeliai%VERSION%
set ZIP_NAME=%FOLDER_NAME%.zip
set TEMP_DIR=%TEMP%\%FOLDER_NAME%

echo Creating release: %ZIP_NAME%
echo.

REM Clean up temp folder if exists
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"

REM Create temp folder
mkdir "%TEMP_DIR%"

REM Copy files (excluding .git, seni, doc, .gitignore, config files, zip files, release script)
echo Copying files...
robocopy . "%TEMP_DIR%" /E /XD .git seni doc /XF .gitignore Darbeliai_config.mat Darbeliai_config.bak *.zip create_release.cmd /NFL /NDL /NJH /NJS

REM Delete existing zip if exists
if exist "%ZIP_NAME%" del "%ZIP_NAME%"

REM Create zip using PowerShell
echo Creating zip...
powershell -Command "Compress-Archive -Path '%TEMP_DIR%' -DestinationPath '%ZIP_NAME%' -Force"

REM Clean up temp folder
rmdir /s /q "%TEMP_DIR%"

echo.
echo ========================================
echo Created: %ZIP_NAME%
echo ========================================
echo.
pause
