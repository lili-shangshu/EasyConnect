//
//  NSData+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "NSData+NATools.h"

@implementation NSData (NATools)

- (NSDictionary *)NA_dataToNSDictionary
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

- (NSArray *)NA_dataToNSArray
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

@end
