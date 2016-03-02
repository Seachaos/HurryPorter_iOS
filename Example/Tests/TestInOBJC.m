//
//  TestInOBJC.m
//  HurryPorter
//
//  Created by 葉建胤 on 2016/2/25.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HurryPorter/HurryPorter-umbrella.h>
#import "HurryPorter_Example-Bridging-Header.h"
#import "HurryPorter_Tests-Bridging-Header.h"

@interface TestInOBJC : XCTestCase

@end

@implementation TestInOBJC

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONConvert{
    NSDictionary *dict = @{@"AA":@"BB"};
    NSString *json = [HurryPorterHelper dictToString:dict];
    XCTAssertNotNil(json);
    XCTAssertTrue([@"{\"AA\":\"BB\"}" isEqualToString:json]);
}

- (void)testMD5{
    NSString *expect = @"da7a4c1171e14afc0744bf2f34d8515f";
    NSString *md5 = [HurryPorterOC MD5:@"testaaaa"];
    XCTAssertTrue([expect isEqualToString:md5]);
}

@end
