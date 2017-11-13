//
//  UITextField+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/11.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITextField+NATools.h"

@implementation UITextField (NATools)

- (BOOL)isTextFieldEmpty
{
    return (!self.text || [self.text isEqualToString:@""]);
}

@end
