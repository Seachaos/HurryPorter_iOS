#!/bin/bash

# build framework
cd HurryPorter_iOS
xctool clean -sdk iphonesimulator -project HurryPorter_iOS.xcodeproj -scheme BuildFramework build
cd ../


# copy framework
rm -rf ./HurryPorterTestAPP_iOS/HurryPorter_iOS.framework
cp -r HurryPorter_iOS/Output/HurryPorter_iOS-Debug-iphoneuniversal/HurryPorter_iOS.framework ./HurryPorterTestAPP_iOS/