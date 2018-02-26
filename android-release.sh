#!/usr/bin/env bash -e

BUILD_ENVIRONMENT=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).BUILD_ENVIRONMENT);"  android-config.json`
echo 'Build env:' $BUILD_ENVIRONMENT

WORKSPACE=`pwd`
PROJECT_NAME=$(cat package.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')
PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')

echo 'Project name:' $PROJECT_NAME
echo 'Project version:' $PACKAGE_VERSION

# Reset cache
NEED_RESET_CACHE=`node -e "console.log(JSON.parse(require('fs').readFileSync(process.argv[1]), null, 4).NEED_RESET_CACHE);"  android-config.json`
if [ "$NEED_RESET_CACHE" == true ]
then
    echo 'Reset cache'
    rm -rf node_modules/ && npm cache clean --force
fi

# Install dependencies
echo 'Install dependencies'
npm config set prefix ${WORKSPACE}
npm install

# Cleanup Android
echo 'Check android release gradle: '
node ${WORKSPACE}/android-release-gradle-fix.js
echo 'Cleanup android'
mkdir -p ${WORKSPACE}/android/app/src/main/assets
rm -rf ${WORKSPACE}/android/app/build

# React native build bundle
echo 'Build bundle'
react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.bundle --assets-dest android/app/src/main/res 
export ENVFILE=.env.${BUILD_ENVIRONMENT}

# Android build script
echo 'Start build apk'
# After export: .apk file place at: ${WORKSPACE}/android/app/build/outputs/apk/
cd ${WORKSPACE}/android && ./gradlew assembleRelease
