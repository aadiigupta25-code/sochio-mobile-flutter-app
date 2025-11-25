@echo off
echo Setting up GitHub repository...

echo.
echo Step 1: Add remote repository
echo Please run: git remote add origin https://github.com/YOUR_USERNAME/era_shop.git
echo Replace YOUR_USERNAME with your actual GitHub username
echo.

echo Step 2: Push to GitHub
echo git branch -M main
echo git push -u origin main
echo.

echo Step 3: Set up repository secrets for CI/CD
echo Go to GitHub repository settings ^> Secrets and variables ^> Actions
echo Add these secrets:
echo - KEYSTORE_BASE64: Base64 encoded keystore file
echo - KEYSTORE_PASSWORD: Your keystore password
echo - KEY_PASSWORD: Your key password
echo - KEY_ALIAS: Your key alias
echo.

echo Step 4: Generate keystore if needed
echo keytool -genkey -v -keystore sochio-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sochio
echo.

echo Step 5: Convert keystore to base64
echo certutil -encode sochio-release-key.jks keystore.txt
echo Then copy the content between BEGIN/END lines
echo.

pause