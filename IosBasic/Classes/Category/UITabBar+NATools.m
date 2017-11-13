//
//  UITabBar+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/31.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITabBar+NATools.h"

#define kBadgePointKey 233445

@implementation UITabBar (NATools)

- (void)showBagePont:(BOOL)show forIndex:(NSInteger)index
{
    UIView *view = [self viewWithTag:kBadgePointKey+index];
    
    CGFloat itemWith = (NAScreenWidth/self.items.count);
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake((itemWith*index)+(itemWith*0.65f), 5.f, 6.f, 6.f)];
        view.layer.cornerRadius = view.width/2.f;
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor redColor];
        view.tag = kBadgePointKey+index;
        [self addSubview:view];
    }
    
    view.hidden = !show;
}

- (void)showBagePont:(BOOL)show withNum:(NSInteger)number forIndex:(NSInteger)index{
    
    UILabel *lable = [self viewWithTag:kBadgePointKey+index];
    CGFloat itemWith = (NAScreenWidth/self.items.count);
    
    if (!lable) {
        lable = [[UILabel alloc] initWithFrame:CGRectMake((itemWith*index)+(itemWith*0.65f), 5.f, 12.f, 12.f)];
        lable.font = [UIFont defaultTextFontWithSize:10];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.layer.cornerRadius = lable.width/2.f;
        lable.layer.masksToBounds = YES;
        lable.clipsToBounds = YES;
        lable.backgroundColor = [UIColor redColor];
        lable.tag = kBadgePointKey+index;
        [self addSubview:lable];
    }
    lable.text = [NSString stringWithFormat:@"%d",number];
    lable.hidden = !show;
    
    if (number == 0) {
        lable.hidden = YES;
    }
}
@end
