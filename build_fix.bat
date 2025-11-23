@echo off
echo ========================================
echo Fixing Build Issues and Building AAB
echo ========================================
echo.

echo Step 1: Cleaning Gradle cache...
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul

echo.
echo Step 2: Cleaning Flutter build...
call flutter clean

echo.
echo Step 3: Getting dependencies...
call flutter pub get

echo.
echo Step 4: Building App Bundle (AAB)...
call flutter build appbundle --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo AAB Location: build\app\outputs\bundle\release\app-release.aab
echo.
pause
