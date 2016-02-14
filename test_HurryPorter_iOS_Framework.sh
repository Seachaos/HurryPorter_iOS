#!/bin/bash
set -ev

cd HurryPorter_iOS
xctool clean -sdk iphonesimulator -project HurryPorter_iOS.xcodeproj -scheme HurryPorter_iOS build test
cd ../
