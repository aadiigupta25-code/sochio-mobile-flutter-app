# Deployment Guide

## GitHub Setup

### 1. Repository Secrets
Add these secrets in GitHub repository settings:

- `KEYSTORE_BASE64`: Base64 encoded keystore file
- `KEYSTORE_PASSWORD`: Keystore password
- `KEY_PASSWORD`: Key password  
- `KEY_ALIAS`: Key alias

### 2. Generate Keystore (if needed)
```bash
keytool -genkey -v -keystore sochio-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sochio
```

### 3. Convert Keystore to Base64
```bash
# On Windows:
certutil -encode sochio-release-key.jks keystore.txt
# Then copy content between BEGIN/END lines

# On Mac/Linux:
base64 -i sochio-release-key.jks | pbcopy
```

## Play Store Deployment

### 1. Build App Bundle
The GitHub Action automatically builds AAB files for Play Store.

### 2. Upload to Play Console
1. Download the AAB from GitHub Actions artifacts
2. Upload to Google Play Console
3. Complete store listing
4. Submit for review

## Local Build Commands
```bash
# Clean and get dependencies
flutter clean && flutter pub get

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

## Troubleshooting
- Ensure Java 17 is installed
- Check keystore file permissions
- Verify all secrets are set in GitHub