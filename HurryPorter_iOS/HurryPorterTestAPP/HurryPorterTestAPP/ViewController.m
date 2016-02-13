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

@implementation ViewController{
    UISnape *snape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    snape = [UISnape new];
    [self.view addSubview:snape];
    snape.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    snape.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - test method

- (void)snapeReadyForTest:(UISnape *)_snape{
    [snape log:@"SNAPE READY FOR TEST"];
    
    [snape test:@"Post Test" code:^UISnapeTestResult(UISnape *s, SnapeTaskObject *task, NSString *jobId){
        HurryPorter *porter = [[HurryPorter alloc] init];
        [porter makeRequest:^NSDictionary*(HurryPorter *porter){
            return @{@"First Name":@"Hurry",
                     @"Last Name":@"Porter"};
        } onSuccess:^void HUP_PARAM_SUCCESS{
            NSLog(@"success resp:%@", raw);
            NSLog(@"json is:%@", dict);
            [task success];
        } onFailed:^void HUP_PARAM_FAILED{
            NSLog(@"failed resp:%@", raw);
            [task failed];
        } url:@"http://www.myandroid.tw/test/post.php"];
        return SUCCESS;
    }];
}

@end
