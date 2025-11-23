@echo off
echo ========================================
echo Building Sochio App for Play Store
echo ========================================
echo.

echo Step 1: Cleaning previous builds...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building Release APK...
call flutter build apk --release

echo.
echo Step 4: Building App Bundle (AAB) for Play Store...
call flutter build appbundle --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo AAB Location: build\app\outputs\bundle\release\app-release.aab
echo.
echo Upload AAB file to Play Store!
echo ========================================
pause
