#!/bin/bash
set -ev

# build framework
# cd HurryPorter_iOS
# xctool clean -sdk iphonesimulator -project HurryPorter_iOS.xcodeproj -scheme BuildFramework build
# cd ../


# copy framework
# rm -rf ./HurryPorter_iOS/HurryPorterTestAPP/HurryPorter_iOS.framework
# cp HurryPorter_iOS/Output/HurryPorter_iOS-Debug-iphoneuniversal/HurryPorter_iOS.framework ./HurryPorter_iOS/HurryPorterTestAPP

xctool clean -sdk iphonesimulator -workspace HurryPorter.xcworkspace -scheme HurryPorterTestAPP build test
