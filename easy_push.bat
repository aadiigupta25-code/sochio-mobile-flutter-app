@echo off
echo 🚀 Easy Push Script
echo.

echo Adding all changes...
git add .

echo.
set /p message="Enter commit message: "

echo.
echo Committing changes...
git commit -m "%message%"

echo.
echo Pushing to GitHub...
git push origin main

echo.
echo ✅ Push complete! Check GitHub Actions for build status.
pause