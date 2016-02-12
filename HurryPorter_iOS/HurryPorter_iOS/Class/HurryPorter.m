//
//  HurryPorter.m
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

#import <UIKit/UIKit.h>
#import "HurryPorter.h"



@interface HurryPorter()<NSURLConnectionDelegate>{
}

@property (nonatomic, retain) NSMutableData *responseData;

@property (nonatomic, copy) void (^callback_onSuccess) HUP_PARAM_SUCCESS;
@property (nonatomic, copy) void (^callback_onFailed) HUP_PARAM_FAILED;

@end

@implementation HurryPorter

@synthesize requstMethod, timeout, encoding, responseString, osVersion;
@synthesize callback_onFailed, callback_onSuccess;
@synthesize responseData;

- (id)init{
    self = [super init];
    encoding = NSUTF8StringEncoding;
    timeout = 30;
    osVersion = [[UIDevice currentDevice].systemVersion floatValue];
    return self;
}
#pragma mark - HTTP Request

- (void) _preparePost:(NSMutableURLRequest*)request postData:(NSDictionary*)postDict{
    [request setHTTPMethod:HUP_METHOD_POST];
    
    // convert post string
    NSMutableString *postString = [NSMutableString new];
    for(NSString *key in postDict){
        if([postString length]>0){
            [postString appendString:@"&"];
        }
        NSString *value = postDict[key];
        if(osVersion>=9){
            value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }else{
            value = [value stringByAddingPercentEscapesUsingEncoding:encoding];
        }
        [postString appendString:[NSString stringWithFormat:@"%@=%@",
                                 key, value]];
    }
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)makeRequest:(NSDictionary* (^)(HurryPorter *porter))prepare
          onSuccess:(void (^)HUP_PARAM_SUCCESS)onSuccess
           onFailed:(void (^)HUP_PARAM_FAILED)onFailed
                url:(NSString*)url{
    callback_onSuccess = onSuccess;
    callback_onFailed = onFailed;
    NSDictionary *data = prepare(self);
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];;
//    request.timeoutInterval = timeout;
    
    // check request method and prepare data
    if(self.requstMethod==nil||[HUP_METHOD_POST isEqualToString:self.requstMethod]){
        [self _preparePost:request postData:data];
    }
    
    // Will for over then ios 9...
//    if(osVersion>=9){
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *erro)
//            {
//                [self onReceiveDataFinish:data];
//            }];
//        [sessionDataTask resume];
//    }else{
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    }
}

- (void)onReceiveDataFinish:(NSData*)data{
    responseString = [[NSString alloc] initWithData:data encoding:encoding];
    callback_onSuccess(responseString, [HurryPorter stringToDict:responseString], self);
}

#pragma mark - NSURLConnectionDelegate

// start
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    responseData = [[NSMutableData alloc] init];
}

// receive
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

// finish
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self onReceiveDataFinish:responseData];
}

// failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    responseString = [[NSString alloc] initWithData:responseData encoding:encoding];
    callback_onFailed(responseString, self);
}

#pragma mark - JSON Convert

+ (NSString*)dictToString:(id)obj{
    return [self jsonToString:obj];
}
+ (NSString*)jsonToString:(id)obj{
    // NSJSONWritingOptions
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                           options:0
                                                             error:nil];
        if (! jsonData) {
            return @"{}";
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    }
    @catch (NSException *e) {
        
    }
    return nil;
}

+ (NSDictionary*)stringToDict:(NSString*)string{
    return (NSDictionary*)[self stringToObject:string];
}
+ (NSArray*)stringToArray:(NSString*)string{
    return (NSArray*)[self stringToObject:string];
}
+ (id)stringToObject:(NSString*)string{
    @try{
        NSError *jsonParsingError = nil;
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(json!=nil){
            return json;
        }
    }@catch(NSException *e){
        
    }
    return nil;
    
}

@end
