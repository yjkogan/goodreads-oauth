//
//  NSString+URLEncoding.m
//  IdeaFlasher Authentication
//
//  Created by Christian Hansen on 24/11/12.
//  Copyright (c) 2012 Kwamecorp. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)


- (NSString *)utf8AndURLEncode
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}


+ (NSString *)getUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}


+ (NSString *)getNonce
{
    // uuid is simplified a bit, also the full uuid can be used as nonce
    NSString *uuid = [self getUUID];
    return [[uuid substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""].lowercaseString;
}

@end
