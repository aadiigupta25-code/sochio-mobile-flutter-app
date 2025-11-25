# Set Java home to correct location
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot"

# Verify Java
Write-Host "Java Home: $env:JAVA_HOME" -ForegroundColor Green
java -version

# Change to project directory
$projectDir = "C:\Users\Kartikey\Desktop\Flutter App\Flutter App\era_shop"
Set-Location $projectDir

# Clear gradle caches
Write-Host "Clearing gradle caches..." -ForegroundColor Yellow
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\wrapper" -ErrorAction SilentlyContinue

# Clean and rebuild
Write-Host "Running flutter clean..." -ForegroundColor Yellow
flutter clean

Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "Building APK..." -ForegroundColor Yellow
flutter build apk --debug

Write-Host "Build complete!" -ForegroundColor Green
