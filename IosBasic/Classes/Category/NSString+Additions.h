//
//  NSString+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/11.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (instancetype)jsonStringFromDictionary:(NSDictionary *)dict;
- (id)jsonStringToArrayOrDictionary;

@end
