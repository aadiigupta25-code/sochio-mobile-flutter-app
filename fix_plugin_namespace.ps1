# Comprehensive Plugin Namespace Fix for Android Build
Write-Host "Starting plugin namespace fix..." -ForegroundColor Cyan

# Plugin 1: flutter_inappwebview  
$plugin1Path = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\flutter_inappwebview-5.8.0\android\build.gradle"
if (Test-Path $plugin1Path) {
    $content1 = Get-Content $plugin1Path -Raw
    
    # Check if namespace already exists
    if ($content1 -match 'namespace\s+"com\.pichillilorenzo\.flutter_inappwebview"') {
        Write-Host "[✓] flutter_inappwebview already has namespace" -ForegroundColor Green
    } else {
        # Add namespace after 'android {' line
        $content1 = $content1 -replace '(android\s*\{)(\r?\n)',  "`$1`$2    namespace ""com.pichillilorenzo.flutter_inappwebview""`$2"
        Set-Content -Path $plugin1Path -Value $content1 -NoNewline
        Write-Host "[✓] Added namespace to flutter_inappwebview" -ForegroundColor Green
    }
} else {
    Write-Host "[!] flutter_inappwebview not found" -ForegroundColor Red
    exit 1
}

Write-Host""
Write-Host "Plugin fixes complete!" -ForegroundColor Cyan
