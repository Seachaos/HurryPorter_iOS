//
//  TestInOBJC.m
//  HurryPorter
//
//  Created by 葉建胤 on 2016/2/25.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HurryPorter_Example-Bridging-Header.h"

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
    NSString *json = [HurryPorter dictToString:dict];
    XCTAssertNotNil(json);
    XCTAssertTrue([@"{\"AA\":\"BB\"}" isEqualToString:json]);
}

@end
