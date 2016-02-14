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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SnapeTaskObject.h"

typedef enum _UISnapeTestResult{
    WAIT_FOR_RESULT = -1,
    FAILED = 0,
    SUCCESS = 1
} UISnapeTestResult;

@protocol UISnapeDelegate <NSObject>

- (void)snapeReadyForTest:(UISnape*)snape;

@end

@interface UISnape : UIView


@property (nonatomic, assign) id<UISnapeDelegate> delegate;

- (id)initWithDelegate:(id<UISnapeDelegate>)delegate;

- (UISnapeTestResult)test:(NSString*)name code:(UISnapeTestResult(^)(UISnape *snape, SnapeTaskObject *task, NSString *taskId))testBlock;
- (UISnapeTestResult)waitForResult;

- (void)log:(NSString*)msg;
- (void)logSuccess:(NSString*)msg;
- (void)logFailed:(NSString*)msg;

- (BOOL)success:(NSString*)taskId;
- (BOOL)failed:(NSString*)taskId;
- (BOOL)failed:(NSString*)taskId because:(NSString*)reason;


@end