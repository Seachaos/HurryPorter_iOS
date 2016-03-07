//
//  NSObject_UsingInOBJC.h
//  HurryPorter
//
//  Created by 葉建胤 on 2016/2/25.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

#import "NSObject_UsingInOBJC.h"
#import "HurryPorter_Example-Swift.h"

@implementation UsingInOBJC

- (void) testHurryPorter{
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
    
}

@end