@echo off
echo ========================================
echo Installing Flutter SDK
echo ========================================

echo Downloading Flutter SDK...
curl -o flutter_windows.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip

echo Extracting Flutter...
powershell -command "Expand-Archive -Path flutter_windows.zip -DestinationPath C:\ -Force"

echo Adding Flutter to PATH...
setx PATH "%PATH%;C:\flutter\bin" /M

echo Flutter installation complete!
echo Please restart command prompt and run: flutter doctor
pause