# PowerShell script to set up Android folder structure for Flutter project
# Project: Sochio
# Package: com.sochio.app

$projectPath = "c:\Sochio Files\Source Code\Flutter App\era_shop"
$packageName = "com.sochio.app"
$appName = "Sochio"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Android Setup for $appName Flutter App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $projectPath

# Step 1: Create folder structure
Write-Host "[1/8] Creating Android folder structure..." -ForegroundColor Yellow
$folders = @(
    "android\app\src\main\kotlin\com\sochio\app",
    "android\app\src\main\res\values",
    "android\app\src\main\res\mipmap-hdpi",
    "android\app\src\main\res\mipmap-mdpi",
    "android\app\src\main\res\mipmap-xhdpi",
    "android\app\src\main\res\mipmap-xxhdpi",
    "android\app\src\main\res\mipmap-xxxhdpi",
    "android\gradle\wrapper"
)
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
}
Write-Host "   ✓ Folders created" -ForegroundColor Green

# Step 2: Create AndroidManifest.xml
Write-Host "[2/8] Generating AndroidManifest.xml..." -ForegroundColor Yellow
$manifestContent = @"
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="$packageName">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application
        android:label="$appName"
        android:name="`${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2"/>
    </application>
</manifest>
"@
Set-Content -Path "android\app\src\main\AndroidManifest.xml" -Value $manifestContent
Write-Host "   ✓ AndroidManifest.xml created" -ForegroundColor Green

# Step 3: Create MainActivity.kt
Write-Host "[3/8] Creating MainActivity.kt..." -ForegroundColor Yellow
$mainActivityContent = @"
package $packageName

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
"@
Set-Content -Path "android\app\src\main\kotlin\com\sochio\app\MainActivity.kt" -Value $mainActivityContent
Write-Host "   ✓ MainActivity.kt created" -ForegroundColor Green

# Step 4: Create app/build.gradle
Write-Host "[4/8] Generating Gradle files..." -ForegroundColor Yellow
$appBuildGradleContent = @"
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "`$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    compileSdkVersion 33
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "$packageName"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.7.10"
}
"@
Set-Content -Path "android\app\build.gradle" -Value $appBuildGradleContent

# Create build.gradle
$buildGradleContent = @"
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:`$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "`${rootProject.buildDir}/`${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
"@
Set-Content -Path "android\build.gradle" -Value $buildGradleContent

# Create settings.gradle
$settingsGradleContent = @"
include ':app'

def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
def properties = new Properties()

assert localPropertiesFile.exists()
localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }

def flutterSdkPath = properties.getProperty("flutter.sdk")
assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
apply from: "`$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"
"@
Set-Content -Path "android\settings.gradle" -Value $settingsGradleContent

# Create gradle.properties
$gradlePropertiesContent = @"
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
"@
Set-Content -Path "android\gradle.properties" -Value $gradlePropertiesContent

# Create gradle-wrapper.properties
$gradleWrapperContent = @"
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
"@
Set-Content -Path "android\gradle\wrapper\gradle-wrapper.properties" -Value $gradleWrapperContent
Write-Host "   ✓ Gradle files created" -ForegroundColor Green

# Step 5: Create styles.xml
Write-Host "[5/8] Creating styles.xml..." -ForegroundColor Yellow
$stylesContent = @"
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
"@
Set-Content -Path "android\app\src\main\res\values\styles.xml" -Value $stylesContent
Write-Host "   ✓ styles.xml created" -ForegroundColor Green

# Step 6: Create .gitignore
Write-Host "[6/8] Creating .gitignore..." -ForegroundColor Yellow
$gitignoreContent = @"
gradle-wrapper.jar
/.gradle
/captures/
/gradlew
/gradlew.bat
/local.properties
GeneratedPluginRegistrant.java
*.iml
*.class
.gradle
/build/
.idea
.DS_Store
"@
Set-Content -Path "android\.gitignore" -Value $gitignoreContent
Write-Host "   ✓ .gitignore created" -ForegroundColor Green

# Step 7: Git operations
Write-Host "[7/8] Adding files to git..." -ForegroundColor Yellow
git add android .metadata 2>$null
Write-Host "   ✓ Files added to git" -ForegroundColor Green

Write-Host "[8/8] Committing and pushing to GitHub..." -ForegroundColor Yellow
git commit -m "Add Android folder for FlutLab compatibility" 2>$null
git push origin main 2>$null
Write-Host "   ✓ Changes committed and pushed" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✓ Android setup completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Created:" -ForegroundColor White
Write-Host "  • Android folder structure" -ForegroundColor Gray
Write-Host "  • AndroidManifest.xml (package: $packageName)" -ForegroundColor Gray
Write-Host "  • MainActivity.kt" -ForegroundColor Gray
Write-Host "  • Gradle configuration files" -ForegroundColor Gray
Write-Host "  • styles.xml" -ForegroundColor Gray
Write-Host "  • .gitignore" -ForegroundColor Gray
Write-Host ""
Write-Host "Git:" -ForegroundColor White
Write-Host "  • Files committed" -ForegroundColor Gray
Write-Host "  • Pushed to origin/main" -ForegroundColor Gray
Write-Host ""
