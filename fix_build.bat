@echo off
echo Starting Flutter build fix...

echo Cleaning build artifacts...
flutter clean

echo Removing pubspec.lock...
if exist pubspec.lock del pubspec.lock

echo Removing .dart_tool directory...
if exist .dart_tool rmdir /s /q .dart_tool

echo Getting dependencies...
flutter pub get

echo Verifying package resolution...
flutter pub deps

echo Build fix complete. Now run: flutter build apk --release
pause