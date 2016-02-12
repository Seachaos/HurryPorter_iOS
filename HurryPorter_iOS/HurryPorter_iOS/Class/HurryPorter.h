//
//  HurryPorter.h
//  HurryPorter_iOS
//
//  Created by 葉建胤 on 2/7/16.
//  Copyright © 2016 Seachaos. All rights reserved.
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

#define HUP_METHOD_POST @"POST"
#define HUP_PARAM_SUCCESS (NSString *raw, NSDictionary* dict, HurryPorter *porter)
#define HUP_PARAM_FAILED (NSString *raw, HurryPorter *porter)

@interface HurryPorter : NSObject

@property (nonatomic, retain) NSString *requstMethod;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, assign) float osVersion;
@property (nonatomic, assign) NSStringEncoding encoding;

- (void)makeRequest:(NSDictionary* (^)(HurryPorter *porter))prepare
          onSuccess:(void (^)HUP_PARAM_SUCCESS)onSuccess
           onFailed:(void (^)HUP_PARAM_FAILED)onFailed
                url:(NSString*)url;

#pragma mark - JSON Convert
+ (NSString*)dictToString:(id)obj;
+ (NSString*)jsonToString:(id)obj;
+ (NSDictionary*)stringToDict:(NSString*)string;
+ (NSArray*)stringToArray:(NSString*)string;
+ (id)stringToObject:(NSString*)string;

@end
