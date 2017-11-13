//
//  UITextView+Additions.m
//  IosBasic
//
//  Created by junshi on 16/3/25.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "UITextView+Additions.h"

@implementation UITextView (Additions)

- (BOOL)isTextViewEmpty
{
    return (!self.text || [self.text isEqualToString:@""]);
}

@end
