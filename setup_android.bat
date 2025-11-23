@echo off
echo Setting up Android structure for Sochio Flutter app...

cd /d "c:\Sochio Files\Source Code\Flutter App\era_shop"

echo Creating Android folder structure...
mkdir android\app\src\main\kotlin\com\sochio\app 2>nul
mkdir android\app\src\main\res\values 2>nul
mkdir android\app\src\main\res\mipmap-hdpi 2>nul
mkdir android\app\src\main\res\mipmap-mdpi 2>nul
mkdir android\app\src\main\res\mipmap-xhdpi 2>nul
mkdir android\app\src\main\res\mipmap-xxhdpi 2>nul
mkdir android\app\src\main\res\mipmap-xxxhdpi 2>nul
mkdir android\gradle\wrapper 2>nul

echo Creating AndroidManifest.xml...
(
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"
echo     package="com.sochio.app"^>
echo.
echo     ^<uses-permission android:name="android.permission.INTERNET"/^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/^>
echo.
echo     ^<application
echo         android:label="Sochio"
echo         android:name="${applicationName}"
echo         android:icon="@mipmap/ic_launcher"^>
echo         ^<activity
echo             android:name=".MainActivity"
echo             android:exported="true"
echo             android:launchMode="singleTop"
echo             android:theme="@style/LaunchTheme"
echo             android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
echo             android:hardwareAccelerated="true"
echo             android:windowSoftInputMode="adjustResize"^>
echo             ^<meta-data
echo                 android:name="io.flutter.embedding.android.NormalTheme"
echo                 android:resource="@style/NormalTheme"/^>
echo             ^<intent-filter^>
echo                 ^<action android:name="android.intent.action.MAIN"/^>
echo                 ^<category android:name="android.intent.category.LAUNCHER"/^>
echo             ^</intent-filter^>
echo         ^</activity^>
echo         ^<meta-data
echo             android:name="flutterEmbedding"
echo             android:value="2"/^>
echo     ^</application^>
echo ^</manifest^>
) > android\app\src\main\AndroidManifest.xml

echo Creating MainActivity.kt...
(
echo package com.sochio.app
echo.
echo import io.flutter.embedding.android.FlutterActivity
echo.
echo class MainActivity: FlutterActivity^(^) {
echo }
) > android\app\src\main\kotlin\com\sochio\app\MainActivity.kt

echo Creating app/build.gradle...
(
echo def localProperties = new Properties^(^)
echo def localPropertiesFile = rootProject.file^('local.properties'^)
echo if ^(localPropertiesFile.exists^(^)^) {
echo     localPropertiesFile.withReader^('UTF-8'^) { reader -^>
echo         localProperties.load^(reader^)
echo     }
echo }
echo.
echo def flutterRoot = localProperties.getProperty^('flutter.sdk'^)
echo if ^(flutterRoot == null^) {
echo     throw new GradleException^("Flutter SDK not found. Define location with flutter.sdk in the local.properties file."^)
echo }
echo.
echo def flutterVersionCode = localProperties.getProperty^('flutter.versionCode'^)
echo if ^(flutterVersionCode == null^) {
echo     flutterVersionCode = '1'
echo }
echo.
echo def flutterVersionName = localProperties.getProperty^('flutter.versionName'^)
echo if ^(flutterVersionName == null^) {
echo     flutterVersionName = '1.0'
echo }
echo.
echo apply plugin: 'com.android.application'
echo apply plugin: 'kotlin-android'
echo apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
echo.
echo android {
echo     compileSdkVersion 33
echo     ndkVersion flutter.ndkVersion
echo.
echo     compileOptions {
echo         sourceCompatibility JavaVersion.VERSION_1_8
echo         targetCompatibility JavaVersion.VERSION_1_8
echo     }
echo.
echo     kotlinOptions {
echo         jvmTarget = '1.8'
echo     }
echo.
echo     sourceSets {
echo         main.java.srcDirs += 'src/main/kotlin'
echo     }
echo.
echo     defaultConfig {
echo         applicationId "com.sochio.app"
echo         minSdkVersion 21
echo         targetSdkVersion 33
echo         versionCode flutterVersionCode.toInteger^(^)
echo         versionName flutterVersionName
echo     }
echo.
echo     buildTypes {
echo         release {
echo             signingConfig signingConfigs.debug
echo         }
echo     }
echo }
echo.
echo flutter {
echo     source '../..'
echo }
echo.
echo dependencies {
echo     implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.7.10"
echo }
) > android\app\build.gradle

echo Creating build.gradle...
(
echo buildscript {
echo     ext.kotlin_version = '1.7.10'
echo     repositories {
echo         google^(^)
echo         mavenCentral^(^)
echo     }
echo.
echo     dependencies {
echo         classpath 'com.android.tools.build:gradle:7.2.0'
echo         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
echo     }
echo }
echo.
echo allprojects {
echo     repositories {
echo         google^(^)
echo         mavenCentral^(^)
echo     }
echo }
echo.
echo rootProject.buildDir = '../build'
echo subprojects {
echo     project.buildDir = "${rootProject.buildDir}/${project.name}"
echo }
echo subprojects {
echo     project.evaluationDependsOn^(':app'^)
echo }
echo.
echo tasks.register^("clean", Delete^) {
echo     delete rootProject.buildDir
echo }
) > android\build.gradle

echo Creating settings.gradle...
(
echo include ':app'
echo.
echo def localPropertiesFile = new File^(rootProject.projectDir, "local.properties"^)
echo def properties = new Properties^(^)
echo.
echo assert localPropertiesFile.exists^(^)
echo localPropertiesFile.withReader^("UTF-8"^) { reader -^> properties.load^(reader^) }
echo.
echo def flutterSdkPath = properties.getProperty^("flutter.sdk"^)
echo assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
echo apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"
) > android\settings.gradle

echo Creating gradle.properties...
(
echo org.gradle.jvmargs=-Xmx1536M
echo android.useAndroidX=true
echo android.enableJetifier=true
) > android\gradle.properties

echo Creating gradle-wrapper.properties...
(
echo distributionBase=GRADLE_USER_HOME
echo distributionPath=wrapper/dists
echo zipStoreBase=GRADLE_USER_HOME
echo zipStorePath=wrapper/dists
echo distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
) > android\gradle\wrapper\gradle-wrapper.properties

echo Creating styles.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo     ^<style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar"^>
echo         ^<item name="android:windowBackground"^>@android:color/white^</item^>
echo     ^</style^>
echo     ^<style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar"^>
echo         ^<item name="android:windowBackground"^>?android:colorBackground^</item^>
echo     ^</style^>
echo ^</resources^>
) > android\app\src\main\res\values\styles.xml

echo Creating .gitignore...
(
echo gradle-wrapper.jar
echo /.gradle
echo /captures/
echo /gradlew
echo /gradlew.bat
echo /local.properties
echo GeneratedPluginRegistrant.java
echo *.iml
echo *.class
echo .gradle
echo /build/
echo .idea
echo .DS_Store
) > android\.gitignore

echo Creating .metadata...
(
echo # This file tracks properties of this Flutter project.
echo # Used by Flutter tool to assess capabilities and perform upgrades etc.
echo #
echo # This file should be version controlled and should not be manually edited.
echo.
echo version:
echo   revision: "f1875d570e39de09040c8f79aa13cc56baab8db1"
echo   channel: "stable"
echo.
echo project_type: app
echo.
echo # Tracks metadata for the flutter migrate command
echo migration:
echo   platforms:
echo     - platform: root
echo       create_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo       base_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo     - platform: android
echo       create_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo       base_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo     - platform: ios
echo       create_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo       base_revision: f1875d570e39de09040c8f79aa13cc56baab8db1
echo.
echo   # User provided section
echo.
echo   # List of Local paths ^(relative to this file^) that should be
echo   # ignored by the migrate tool.
echo   #
echo   # Files that are not part of the templates will be ignored by default.
echo   unmanaged_files:
echo     - 'lib/main.dart'
echo     - 'ios/Runner.xcodeproj/project.pbxproj'
) > .metadata

echo Initializing git and committing changes...
git add android .metadata
git commit -m "Add Android configuration for Sochio Flutter app"

echo.
echo ========================================
echo Android setup completed successfully!
echo ========================================
echo.
echo Created:
echo - Android folder structure
echo - AndroidManifest.xml
echo - MainActivity.kt
echo - Gradle files
echo - gradle.properties
echo - .metadata
echo - Git commit
echo.
pause
