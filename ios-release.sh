#!/usr/bin/env bash -e

BUILD_ENVIRONMENT=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).BUILD_ENVIRONMENT);"  ios-config.json`
echo 'Build env:' $BUILD_ENVIRONMENT

WORKSPACE=`pwd`
PROJECT_NAME=$(cat package.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')
PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')
ENV_NAME="${PROJECT_NAME}-${BUILD_ENVIRONMENT}"

BUNDLE_ID=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).BUNDLE_ID);"  ios-config.json`
DEVELOPMENT_TEAM=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).DEVELOPMENT_TEAM);"  ios-config.json`
PROVISIONING_PROFILE_NAME=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).PROVISIONING_PROFILE_NAME);"  ios-config.json`
CODE_SIGN_IDENTITY=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).CODE_SIGN_IDENTITY);"  ios-config.json`
BUILD_HOST=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).BUILD_HOST);"  ios-config.json`

export RCT_NO_LAUNCH_PACKAGER=true 

# Reset cache
NEED_RESET_CACHE=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).NEED_RESET_CACHE);"  ios-config.json`
if [ "$NEED_RESET_CACHE" == true ]
then
    echo 'Reset cache'
    rm -rf $TMPDIR/react-* && rm -rf $TMPDIR/metro-* && watchman watch-del-all && rm -rf ios/build && rm -rf node_modules/ && npm cache clean --force
fi

# Install dependencies
echo 'Install dependencies'
npm config set prefix ${WORKSPACE}
npm install

# Cleanup ios
echo 'Cleanup ios'
rm -rf "${WORKSPACE}/ios/build";
rm -rf "${WORKSPACE}"/ios/*.plist;

# React native build bundle
echo 'Build bundle'
echo ".env.${BUILD_ENVIRONMENT}" > /tmp/envfile;
npm run ios-version; 
react-native bundle --platform ios --dev false --entry-file index.js --bundle-output ios/main.jsbundle

# iOS build script
echo 'Start build ipa'

cd ios
pod install

env DEVELOPER_DIR="/Applications/Xcode.app" /usr/bin/xcodebuild -workspace ${PROJECT_NAME}.xcworkspace/ -scheme ${PROJECT_NAME} -configuration Release CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" archive -archivePath "${WORKSPACE}/ios/build/${ENV_NAME}/${ENV_NAME}.xcarchive" -verbose

cat <<EOT >> manifest-${ENV_NAME}.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>compileBitcode</key>
    <true/>
    <key>method</key>
    <string>development</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>${BUNDLE_ID}</key>
        <string>${PROVISIONING_PROFILE_NAME}</string>
    </dict>
    <key>signingCertificate</key>
    <string>iPhone Developer</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>${DEVELOPMENT_TEAM}</string>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
    <key>manifest</key>
    <dict>        
        <key>appURL</key>
        <string>${BUILD_HOST}/builds/${PROJECT_NAME}/ios/${BUILD_ENVIRONMENT}/${BUILD_NUMBER}/${ENV_NAME}.ipa</string>
        <key>displayImageURL</key>
        <string>${BUILD_HOST}/builds/images/icon57.png</string>
        <key>fullSizeImageURL</key>
        <string>${BUILD_HOST}/builds/images/icon512.png</string>
    </dict>
</dict>
</plist>
EOT

# After export: .ipa + .plist files place at: ${WORKSPACE}/ios/build/${ENV_NAME}
echo 'Export'
${WORKSPACE}/ios-xcbuild.sh -exportArchive -archivePath ${WORKSPACE}/ios/build/${ENV_NAME}/${ENV_NAME}.xcarchive -exportPath ${WORKSPACE}/ios/build/${ENV_NAME} -exportOptionsPlist manifest-${ENV_NAME}.plist
