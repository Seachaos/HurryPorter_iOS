# HurryPorter

[![CI Status](http://img.shields.io/travis/Seachaos/HurryPorter_iOS.svg?style=flat)](https://travis-ci.org/Seachaos/HurryPorter_iOS)
[![Version](https://img.shields.io/cocoapods/v/HurryPorter.svg?style=flat)](http://cocoapods.org/pods/HurryPorter)
[![License](https://img.shields.io/cocoapods/l/HurryPorter.svg?style=flat)](http://cocoapods.org/pods/HurryPorter)
[![Platform](https://img.shields.io/cocoapods/p/HurryPorter.svg?style=flat)](http://cocoapods.org/pods/HurryPorter)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

or see example page:  http://seachaos.github.io/HurryPorter_iOS

### Simple Code


In Swift：

	let porter = HurryPorter()
	porter.makeRequest( {
		(porter)->[String:AnyObject] in
		var dict = [String:AnyObject]()
		dict["name"] = "Hurry"
		dict["value"] = "Porter"
		return dict
	}, onSuccess: {
		(porter, json, raw) in
		NSLog("success:" + raw)
	}, onFailed: {
		(porter, raw, status) in
		NSLog("failed:" + raw)
	}, href: "http://www.myandroid.tw/test/post.php");


In Objective-C：


    NSString *url = @"http://www.myandroid.tw/test/post.php";
    HurryPorter *porter = [HurryPorter new];
    [porter makeRequest:^NSDictionary*(HurryPorter *porter){
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"First Name"] = @"Hurry";
        dict[@"Last Name"] = @"Porter";
        return dict;
    } onSuccess:^void(HurryPorter *porter, NSDictionary *json, NSString *raw){
        NSLog(@"objc success:%@", raw);
    } onFailed :^void(HurryPorter *porter, NSString *raw, NSInteger errorCode){
        NSLog(@"objc failed:%@", raw);        
    } href: url];


More detail on ： http://seachaos.github.io/HurryPorter_iOS



## Installation

HurryPorter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HurryPorter"
```

## Author

Seachaos, ye.jian.yin@gmail.com

## License

HurryPorter is available under the MIT license. See the LICENSE file for more info.
