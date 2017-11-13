//
//  NSArray+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "NSArray+NATools.h"

@implementation NSArray (NATools)

- (NSData *)NA_arrayToNSData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end
