//
//  NSIndexPath+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/6.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NSIndexPath+NATools.h"

@implementation NSIndexPath (NATools)

+ (NSArray *)indexPathsFromRow:(NSInteger)startRow toRow:(NSInteger)endRow inSection:(NSInteger)section
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = (int)startRow; i < endRow; i++) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    return array;
}

@end
