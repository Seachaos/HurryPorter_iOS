//
//  HurryPorterOC.m
//  Pods
//
//  Created by 葉建胤 on 2016/2/28.
//
//

#import "HurryPorterOC.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation HurryPorterOC

+ (NSString*)MD5:(NSString*)value{
    // Create pointer to the string as UTF8
    const char *ptr = [value UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG) strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;
}

+ (NSString*)SHA256:(NSString*)str{
    NSData *dataIn = [str dataUsingEncoding:NSASCIIStringEncoding];
    unsigned char shaBuffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(dataIn.bytes, (CC_LONG)dataIn.length,  shaBuffer);
    NSMutableString *output = [[NSMutableString alloc] init];
    for(int i=0; i<CC_SHA256_DIGEST_LENGTH;i++){
        [output appendFormat:@"%02x", shaBuffer[i]];
    }
    return output;
}

@end
