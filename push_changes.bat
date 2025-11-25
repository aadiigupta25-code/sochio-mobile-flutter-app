@echo off
echo ========================================
echo Pushing Guest Access Changes to GitHub
echo ========================================

git add .
git commit -m "✅ Added Guest Access - No Login Required

🎯 Changes:
- Added GuestHomeScreen for direct access
- Bypassed admin login requirement  
- Users can now browse without login
- Backend connection testing available
- Product browsing enabled

🚀 Now users can:
- Install APK directly
- Browse products as guest
- Test backend connection
- Watch videos without login"

git push origin main

echo ========================================
echo Changes pushed! GitHub Actions will build APK
echo Check: https://github.com/aadiigupta25-code/sochio-mobile-flutter-app/actions
echo ========================================
pause