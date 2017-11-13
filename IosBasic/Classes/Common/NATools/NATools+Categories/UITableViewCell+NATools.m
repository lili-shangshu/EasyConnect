//
//  UITableViewCell+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/17.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITableViewCell+NATools.h"

@implementation UITableViewCell (NATools)

- (void)setInsetWithX:(CGFloat)xpoint
{
    self.separatorInset = UIEdgeInsetsMake(0, xpoint, 0, 0);
    if ([(UITableViewCell *)self respondsToSelector:@selector(setLayoutMargins:)]) {
        [(UITableViewCell *)self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
