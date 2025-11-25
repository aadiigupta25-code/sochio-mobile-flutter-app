@echo off
echo Pushing device_info fix to GitHub...
echo.

git add .
git commit -m "🔧 Fix device_info namespace issue - replace with device_info_plus"
git push origin main

echo.
echo Fix pushed to GitHub! Build should work now.
pause