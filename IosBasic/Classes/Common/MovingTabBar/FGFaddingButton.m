//
//  FGFaddingButton.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/27.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "FGFaddingButton.h"

@implementation FGFaddingButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    FGFaddingButton *button = [super buttonWithType:buttonType];
    if (button) {
        button.lable1 = [[UILabel alloc] init];
        [button.lable1 setLabelWith:nil color:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:15.f] aliment:NSTextAlignmentCenter];
        [button addSubview:button.lable1];
        
        button.lable2 = [[UILabel alloc] init];
        button.lable2.alpha = 0.f;
        [button.lable2 setLabelWith:nil color:[UIColor spLightRedColor] font:[UIFont systemFontOfSize:15.f] aliment:NSTextAlignmentCenter];
        [button addSubview:button.lable2];
    }
    return button;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.lable1.frame = self.bounds;
    self.lable2.frame = self.bounds;
}

@end
