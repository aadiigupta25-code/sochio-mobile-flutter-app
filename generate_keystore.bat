@echo off
echo Generating keystore for Sochio app...

"C:\Program Files\Java\jdk-19\bin\keytool.exe" -genkey -v -keystore sochio-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sochio -storepass Sochio123! -keypass Sochio123! -dname "CN=Sochio App, OU=Development, O=Sochio, L=Delhi, ST=Delhi, C=IN"

echo.
echo Keystore generated successfully!
echo Converting to Base64...

certutil -encode sochio-release-key.jks keystore_base64.txt

echo.
echo Base64 file created: keystore_base64.txt
echo Copy the content between BEGIN/END lines for GitHub secret

echo.
echo GitHub Secrets to add:
echo KEYSTORE_BASE64: [content from keystore_base64.txt]
echo KEYSTORE_PASSWORD: Sochio123!
echo KEY_PASSWORD: Sochio123!
echo KEY_ALIAS: sochio

pause