//
//  NSIndexPath+NATools.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/6.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (NATools)

+ (NSArray *)indexPathsFromRow:(NSInteger)startRow toRow:(NSInteger)endRow inSection:(NSInteger)section;

@end
