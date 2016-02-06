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

#import "HurryPorter.h"

@implementation HurryPorter


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
