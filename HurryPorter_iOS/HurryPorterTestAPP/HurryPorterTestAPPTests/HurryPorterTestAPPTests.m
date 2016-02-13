//
//  HurryPorterTestAPPTests.m
//  HurryPorterTestAPPTests
//
//  Created by 葉建胤 on 2016/2/13.
//  Copyright © 2016年 Seachaos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UISnape.h"

@interface HurryPorterTestAPPTests : XCTestCase

@end

@implementation HurryPorterTestAPPTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


#pragma mark - Test Snape

- (void)testSnapeNilTaskId{
    UISnape *snape = [UISnape new];
    [self measureBlock:^{
        XCTAssertFalse([snape success:nil]);
        XCTAssertFalse([snape success:@"not exists"]);
        XCTAssertFalse([snape failed:nil]);
        XCTAssertFalse([snape failed:@"not exists"]);
    }];
    
    XCTAssertEqual(SUCCESS, [snape test:@"TEST_Success" code:^UISnapeTestResult(UISnape *snape, SnapeTaskObject *task, NSString *jobId){
        return SUCCESS;
    }]);
    XCTAssertEqual(FAILED, [snape test:@"B" code:^UISnapeTestResult(UISnape *snape, SnapeTaskObject *task, NSString *jobId){
        return FAILED;
    }]);
    XCTAssertNotEqual(SUCCESS, [snape test:@"C" code:^UISnapeTestResult(UISnape *snape, SnapeTaskObject *task, NSString *jobId){
        return FAILED;
    }]);
    
    
}

@end
