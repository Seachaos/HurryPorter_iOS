#!/bin/bash
set -ev
./build_iOSFramework.sh

cd ./HurryPorterTestAPP_iOS
xctool clean -sdk iphonesimulator -project HurryPorterTestAPP.xcodeproj -scheme HurryPorterTestAPP build test
cd ../
