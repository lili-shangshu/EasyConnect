//
//  UIFont+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UIFont+NATools.h"

@implementation UIFont (NATools)

+ (instancetype)defaultTextFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
//    return [UIFont systemFontOfSize:size];
}

+ (instancetype)boldDefaultTextFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirNext-Medium" size:size];
//    return [UIFont boldSystemFontOfSize:size];
}

@end
