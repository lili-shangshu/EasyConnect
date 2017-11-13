//
//  UITextField+FGAddition.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/13.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

- (BOOL)isTextFieldEmpty
{
    return (!self.text || [self.text isEqualToString:@""]);
}

@end
