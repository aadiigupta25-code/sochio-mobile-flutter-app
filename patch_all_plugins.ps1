# Aggressive Plugin Namespace Patcher
Write-Host "=== AGGRESSIVE PLUGIN NAMESPACE PATCHER ===" -ForegroundColor Cyan
Write-Host "Scanning and patching all plugins..." -ForegroundColor Yellow

$pubCache = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev"
$patchedCount = 0

$plugins = Get-ChildItem -Path $pubCache -Directory -ErrorAction SilentlyContinue

foreach ($plugin in $plugins) {
    $buildGradlePath = Join-Path $plugin.FullName "android\build.gradle"
    
    if (Test-Path $buildGradlePath) {
        try {
            $content = Get-Content $buildGradlePath -Raw
            
            if ($content -like '*namespace*') { continue }
            
            $pluginName = $plugin.Name -replace '-[\d.]+.*$', ''
            $namespace = switch -Regex ($pluginName) {
                'flutter_inappwebview' { 'com.pichillilorenzo.flutter_inappwebview' }
                'fluttertoast' { 'io.github.ponnamkarthik.toast.fluttertoast' }
                'flutter_local_notifications' { 'com.dexterous.flutterlocalnotifications' }
                'connectivity_plus' { 'dev.fluttercommunity.plus.connectivity' }
                'device_info_plus' { 'dev.fluttercommunity.plus.device_info' }
                'permission_handler' { 'com.baseflow.permissionhandler' }
                'path_provider' { 'io.flutter.plugins.pathprovider' }
                'image_picker' { 'io.flutter.plugins.imagepicker' }
                'url_launcher' { 'io.flutter.plugins.urllauncher' }
                'video_player' { 'io.flutter.plugins.videoplayer' }
                'google_sign_in' { 'io.flutter.plugins.googlesignin' }
                'flutter_stripe' { 'com.flutter.stripe' }
                'razorpay_flutter' { 'com.razorpay.razorpay_flutter' }
                'sign_in_with_apple' { 'com.aboutyou.dart_packages.sign_in_with_apple' }
                'cached_network_image' { 'com.github.renefloor.cached_network_image' }
                default { "com.example.$pluginName" }
            }
            
            $newContent = $content -replace 'android \{', "android {`n    namespace '$namespace'"
            
            if ($newContent -ne $content) {
                Set-Content -Path $buildGradlePath -Value $newContent -NoNewline
                Write-Host "[OK] $pluginName" -ForegroundColor Green
                $patchedCount++
            }
        } catch { }
    }
}

Write-Host ""
Write-Host "Patched $patchedCount plugins" -ForegroundColor Cyan
