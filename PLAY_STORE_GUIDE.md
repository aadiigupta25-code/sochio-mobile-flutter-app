# 🚀 Play Store Upload Guide - Sochio App

## Pre-requisites Checklist ✅

### 1. Google Play Console Account
- [ ] Google Play Developer account banao ($25 one-time fee)
- [ ] https://play.google.com/console pe jao

### 2. App Assets Tayyar Karo
- [ ] App Icon (512x512 PNG)
- [ ] Feature Graphic (1024x500 PNG)
- [ ] Screenshots (minimum 2, max 8)
  - Phone: 16:9 ya 9:16 ratio
  - Recommended: 1080x1920 ya 1920x1080
- [ ] App Description (short & full)
- [ ] Privacy Policy URL (mandatory)

## Build Process 🔨

### Step 1: Keystore Setup
```bash
# Ye command already run kar chuke ho
keytool -genkey -v -keystore c:\Users\Kartikey\Desktop\sochio-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sochio
```

### Step 2: Update key.properties
File: `android/key.properties`
```
storePassword=YOUR_PASSWORD_HERE
keyPassword=YOUR_PASSWORD_HERE
keyAlias=sochio
storeFile=c:\\Users\\Kartikey\\Desktop\\sochio-release-key.jks
```

### Step 3: Build Release
```bash
# Simple way - Run batch file
build_release.bat

# Manual way
flutter clean
flutter pub get
flutter build appbundle --release
```

### Step 4: Test APK (Optional)
```bash
flutter build apk --release
# Install on device: build\app\outputs\flutter-apk\app-release.apk
```

## Play Store Upload Steps 📱

### 1. Create App in Console
1. Play Console pe jao: https://play.google.com/console
2. "Create app" click karo
3. App details fill karo:
   - App name: **Sochio**
   - Default language: **English (United States)**
   - App/Game: **App**
   - Free/Paid: **Free**
   - Accept declarations

### 2. Store Listing Setup
**Main Store Listing:**
- App name: Sochio
- Short description (80 chars max):
  ```
  Shop Live, Shop Smart - Your ultimate live shopping experience
  ```
- Full description (4000 chars max):
  ```
  Sochio is a revolutionary live shopping platform that brings the excitement 
  of live commerce to your fingertips. Shop from live streams, discover 
  trending products, and enjoy a seamless shopping experience.

  Features:
  ✨ Live Shopping Streams
  🛍️ Browse Products in Real-time
  📱 Easy & Secure Checkout
  🎥 Interactive Video Shopping
  💳 Multiple Payment Options
  🚚 Fast Delivery

  Download now and start your live shopping journey!
  ```

**Graphics:**
- App icon: 512x512 PNG
- Feature graphic: 1024x500 PNG
- Phone screenshots: Minimum 2 (1080x1920 recommended)

**Categorization:**
- App category: Shopping
- Tags: shopping, live shopping, e-commerce

**Contact details:**
- Email: your-email@example.com
- Website: https://sochio-backend.onrender.com (optional)
- Privacy policy: MANDATORY - Create one!

### 3. Content Rating
1. "Content rating" section mein jao
2. Questionnaire fill karo
3. Submit for rating

### 4. App Content
- Privacy Policy: URL provide karo (mandatory)
- Ads: Declare if app has ads
- Target audience: Select age groups
- Data safety: Fill data collection details

### 5. Release Setup

**Internal Testing (Recommended First):**
1. "Testing" > "Internal testing" pe jao
2. Create release
3. Upload AAB: `build\app\outputs\bundle\release\app-release.aab`
4. Add testers (email addresses)
5. Review and rollout

**Production Release:**
1. "Production" > "Create new release"
2. Upload AAB file
3. Release name: Version 1.0.1
4. Release notes:
   ```
   Initial release of Sochio - Live Shopping App
   
   Features:
   - User authentication
   - Live video streaming
   - Product browsing
   - Secure checkout
   - Video player integration
   ```
5. Review and rollout

### 6. Countries & Regions
- Select countries where app will be available
- India, US, UK, etc.

### 7. Pricing & Distribution
- Free app
- Select countries
- Accept content guidelines

## Important Files 📁

### AAB File (Upload this to Play Store)
```
build\app\outputs\bundle\release\app-release.aab
```

### APK File (For testing)
```
build\app\outputs\flutter-apk\app-release.apk
```

## Version Updates 🔄

### Update Version in pubspec.yaml
```yaml
version: 1.0.2+2  # Increment this
```

### Build New Release
```bash
flutter clean
flutter build appbundle --release
```

### Upload to Play Console
1. Create new release
2. Upload new AAB
3. Add release notes
4. Review and rollout

## Common Issues & Solutions 🔧

### Issue 1: Keystore not found
**Solution:** Check path in `key.properties` file

### Issue 2: Build fails
**Solution:** 
```bash
flutter clean
flutter pub get
flutter build appbundle --release --verbose
```

### Issue 3: Upload rejected
**Solution:** Check Play Console for specific errors
- Usually privacy policy or content rating missing

### Issue 4: App not appearing
**Solution:** Review process takes 1-7 days

## Security Checklist 🔒

- [ ] Never commit `key.properties` to Git
- [ ] Keep keystore file safe (backup!)
- [ ] Use strong passwords
- [ ] Add `key.properties` to `.gitignore`
- [ ] Store keystore password securely

## Privacy Policy Template 🔐

Create a simple privacy policy at:
- https://www.privacypolicygenerator.info/
- https://app-privacy-policy-generator.firebaseapp.com/

Host it on:
- GitHub Pages (free)
- Your website
- Google Sites (free)

## Support & Help 📞

**Play Console Help:**
https://support.google.com/googleplay/android-developer

**Flutter Documentation:**
https://docs.flutter.dev/deployment/android

**Common Errors:**
https://developer.android.com/studio/publish/upload-bundle

## Final Checklist Before Upload ✅

- [ ] App tested on real device
- [ ] All features working
- [ ] No crashes or bugs
- [ ] Privacy policy ready
- [ ] Screenshots taken
- [ ] App icon ready
- [ ] Feature graphic ready
- [ ] Store listing text ready
- [ ] Content rating completed
- [ ] AAB file built successfully
- [ ] Keystore backed up safely

## Timeline ⏰

- **Internal Testing:** Instant (after upload)
- **Production Review:** 1-7 days
- **App Live:** After approval

---

**Good Luck! 🎉**

Agar koi problem aaye toh mujhe batana!
