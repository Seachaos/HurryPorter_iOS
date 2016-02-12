//
//  ViewController.m
//  HurryPorterTestAPP
//
//  Created by 葉建胤 on 2016/2/13.
//  Copyright © 2016年 Seachaos. All rights reserved.
//

#import "ViewController.h"

#import <HurryPorter_iOS/HurryPorter_iOS.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self testPost];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - test method

- (void)testPost{
    
    HurryPorter *porter = [[HurryPorter alloc] init];
    [porter makeRequest:^NSDictionary*(HurryPorter *porter){
        return @{@"First Name":@"Hurry",
                 @"Last Name":@"Porter"};
    } onSuccess:^void HUP_PARAM_SUCCESS{
        NSLog(@"success resp:%@", raw);
        NSLog(@"json is:%@", dict);
    } onFailed:^void HUP_PARAM_FAILED{
        NSLog(@"failed resp:%@", raw);
    } url:@"http://www.myandroid.tw/test/post.php"];

}

@end
