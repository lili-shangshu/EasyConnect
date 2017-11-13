//
//  NSDictionary+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NATools)

/*
 数据转换
 */

- (NSData *)NA_dictionaryToNSData;

- (BOOL)checkObjectForKey:(NSString *)key;

@end
