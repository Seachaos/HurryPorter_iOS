//
//  UISnape.m
//  HurryPorterTestAPP
//
//  Created by 葉建胤 on 2016/2/13.
//  Copyright © 2016年 Seachaos. All rights reserved.
//

/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Seachaos
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */


#import "UISnape.h"

@interface UISnape() <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@end

@implementation UISnape{
    NSMutableDictionary *taskPool;
    NSMutableArray *tasks;
    BOOL webViewLoaded;
    UISnapeTestResult testResult;
}

@synthesize webView, delegate;

- (id)init{
    self = [super init];
    [self prepareData];
    return self;
}

- (id)initWithDelegate:(id<UISnapeDelegate>)_delegate{
    self = [self init];
    self.delegate = _delegate;
    return self;
}

- (void)setDelegate:(id<UISnapeDelegate>)_delegate{
    delegate = _delegate;
    if(webViewLoaded){
        [delegate snapeReadyForTest:self];
    }
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    webView.frame = frame;
    
}

- (void)log:(NSString*)msg{
    NSLog(@"[SNAPE]%@", msg);
    [self logToHtml:@"appendMsg" msg:msg];
}

- (void)logSuccess:(NSString*)msg{
    NSLog(@"[SNAPE][Success]%@", msg);
    [self logToHtml:@"appendSuccessMsg" msg:msg];
}
- (void)logFailed:(NSString*)msg{
    NSLog(@"[SNAPE][Failed]%@", msg);
    [self logToHtml:@"appendFailedMsg" msg:msg];
}

// test method
- (UISnapeTestResult)test:(NSString*)name code:(UISnapeTestResult(^)(UISnape *snape, SnapeTaskObject *task, NSString *taskId))testBlock{
    
    // new task and set data
    SnapeTaskObject *task = [SnapeTaskObject new];
    [tasks addObject:task];
    [taskPool setObject:task forKey:task.taskId];
    task.name = name;
    task.snape = self;
    
    // do test
    testResult = testBlock(self, task, task.taskId);
    
    // check result or wait?
    switch (testResult) {
        case SUCCESS:
            [self success:task.taskId];
            break;
        case FAILED:
            [self failed:task.taskId];
            break;
        default:
            break;
    }
    return testResult;
}

- (UISnapeTestResult)waitForResult{
    while (testResult==WAIT_FOR_RESULT) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    return testResult;
}

#pragma - for test result call

- (BOOL)success:(NSString*)taskId{
    testResult = SUCCESS;
    SnapeTaskObject *task = [self getTaskByTaskId:taskId];
    if(task==nil){
        return NO;
    }
    [self logSuccess:[NSString stringWithFormat:@"Success: %@", task.name]];
    return YES;
}

- (BOOL)failed:(NSString*)taskId because:(NSString*)reason{
    testResult = FAILED;
    if(taskId==nil){
        return NO;
    }
    SnapeTaskObject *task = [self getTaskByTaskId:taskId];
    if(task==nil){
        return NO;
    }
    [self logFailed:[NSString stringWithFormat:@"Failed:%@", task.name]];
    if(reason==nil){
        [self logFailed:@" > No Reason"];
    }else{
        [self logFailed:[NSString stringWithFormat:@" > Because:%@", reason]];
    }
    return YES;
}

- (BOOL)failed:(NSString*)taskId{
    return [self failed:taskId because:nil];
}

#pragma - Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [[request URL] absoluteString];
    if([url hasPrefix:@"snape://SNAPE_HTML_LOAD_READY"]){
        webViewLoaded = YES;
        if(delegate!=nil){
            [delegate snapeReadyForTest:self];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Prepare(Init)

- (void)prepareData{
    webViewLoaded = NO;
    
    if(taskPool==nil){
        taskPool = [NSMutableDictionary new];
        tasks = [NSMutableArray new];
    }
    
    // prepare webview for debug
    [self prepareWebView];
}

- (void)prepareWebView{
    webView = [UIWebView new];
    [webView setDelegate:self];
    NSData *htmlData = [self loadDataFromResource:@"snape_debug_page" type:@"html"];
    if(htmlData==nil){
        htmlData = [@"HTML not found!" dataUsingEncoding:NSUTF8StringEncoding];
    }
    [webView loadData:htmlData MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:[NSURL URLWithString:@""]];
    [self addSubview:webView];
}

#pragma - private method


- (void)logToHtml:(NSString*)method msg:(NSString*)msg{
    NSString *value = [self htmlEncode:msg];
    NSString *js = [NSString stringWithFormat:@"%@(\"%@\")", method, value];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (NSString*)htmlEncode:(NSString*)html{
    NSString *value = html;
    if([[UIDevice currentDevice].systemVersion floatValue]>=9){
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    }else{
        value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return value;
}


- (NSData*)loadDataFromResource:(NSString*)name type:(NSString*)type{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if(htmlPath==nil){
        htmlPath = [[NSBundle bundleForClass:[UISnape class]] pathForResource:name ofType:type];
    }
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
    
    // if html data is empty or nil, try load from framework bundle resouce
    if(htmlData==nil || [htmlData length]<10){
        htmlPath = [[NSBundle bundleForClass:[UISnape class]] pathForResource:name ofType:type];
        htmlData = [NSData dataWithContentsOfFile:htmlPath];
    }
    return htmlData;
}

- (SnapeTaskObject*)getTaskByTaskId:(NSString*)taskId{
    SnapeTaskObject *task = taskPool[taskId];
    if(task==nil){
        [self failed:nil because:@"Task Not Found"];
        return nil;
    }
    return task;
}
@end
