#!/bin/bash
set -ev

cd HurryPorter_iOS/HurryPorterTestAPP
xctool -sdk iphonesimulator -project HurryPorterTestAPP.xcodeproj -scheme HurryPorterTestAPP build test
cd ../../
