//
//  NSDictionary+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "NSDictionary+NATools.h"

@implementation NSDictionary (NATools)

- (NSData *)NA_dictionaryToNSData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (BOOL)checkObjectForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSNull class]] || !object) {
        NALog(@"------> Null Object For Key : %@", key);
        return NO;
    }
    return YES;
}

@end
