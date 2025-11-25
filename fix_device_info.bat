@echo off
echo Fixing device_info namespace issue...
echo.

REM Remove old pubspec.lock to force dependency resolution
if exist pubspec.lock del pubspec.lock

REM Clean flutter project
flutter clean

REM Get dependencies
flutter pub get

echo.
echo Fixed! Now commit and push changes.
pause