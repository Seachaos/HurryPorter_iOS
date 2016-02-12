//
//  HurryPorter_iOSTests.m
//  HurryPorter_iOSTests
//
//  Created by 葉建胤 on 2/7/16.
//  Copyright © 2016 Seachaos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <HurryPorter_iOS/HurryPorter_iOS.h>

@interface HurryPorter_iOSTests : XCTestCase

@end

@implementation HurryPorter_iOSTests

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

- (void)testJSONConvert{
    
    // test dict(json object) to string
    NSString *expectString = @"{\"subDict\":{\"test\":\"AABBCC\",\"IntValue\":3,\"array\":[3,5,6,7]},\"name\":\"Good\",\"array\":[1,3,5,6,8,9]}";
    NSDictionary *testDict = @{
                               @"name":@"Good",
                               @"array":@[@1,@3,@5,@6,@8,@9],
                               @"subDict":@{
                                       @"test":@"AABBCC",
                                       @"IntValue":@3,
                                       @"array":@[@3,@5,@6,@7]
                                       }
                               };
    NSString *result = [HurryPorter jsonToString:testDict];
    XCTAssertTrue([expectString isEqualToString:result]);
    
    // test array to string
    expectString = @"[1,3,5,7,9]";
    NSArray *array = @[@1,@3,@5,@7,@9];
    result = [HurryPorter jsonToString:array];
    XCTAssertTrue([expectString isEqualToString:result]);
    
    // test string to dict
    expectString = @"{\"AA\":\"BB\"}";
    NSDictionary *exceptDict = @{@"AA":@"BB"};
    testDict = [HurryPorter stringToDict:expectString];
    XCTAssertTrue([testDict isEqual:exceptDict]);
    exceptDict = @{@"BB":@"AA"};
    XCTAssertFalse([testDict isEqual:exceptDict]);
}

- (void)testMakeRequest{
    HurryPorter *porter = [[HurryPorter alloc] init];
    [porter makeRequest:^NSDictionary*(HurryPorter *porter){
        return @{@"First Name":@"Hurry",
                 @"Last Name":@"Porter"};
    } url:@"http://www.myandroid.tw/test/post.php"];
}
@end
