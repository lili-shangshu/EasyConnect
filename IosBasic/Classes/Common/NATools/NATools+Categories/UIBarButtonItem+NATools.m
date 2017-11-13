//
//  UIBarButtonItem+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UIBarButtonItem+NATools.h"
#import "UILabel+NATools.h"
#import "ViewUtils.h"

#define kBadgeViewTag 1443

@implementation UIBarButtonItem (NATools)

+ (instancetype)NA_FlexibleSpaceItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (UIBarButtonItem *)NA_FixedSpaceItem:(CGFloat)width
{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    buttonItem.width = width;
    return buttonItem;
}

+ (instancetype)NA_BarButtonWithtitile:(NSString *)string target:(id)target action:(SEL)action
{
    return [self NA_BarButtonWithtitile:string titleColor:nil target:target action:action];
}

+ (instancetype)NA_BarButtonWithtitile:(NSString *)string titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    if (!titleColor) titleColor = [UIColor gray1];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    if (action) [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image width:(float)width height:(float)height target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [button sizeToFit];
    button.width = width;
    button.height = height;

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image selectedImage:(UIImage *) selctedImage target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selctedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //[button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image backImg:(UIImage *) backImg target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(backImg){
    
        [button setBackgroundImage:backImg forState:UIControlStateNormal];
    }
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image titile:(NSString *)string leftOffSet:(CGFloat)offSet target:(id)target action:(SEL)action
{
    return [self NA_BarButtonWithImage:image titile:string fontSize:15.f leftOffSet:offSet backImg:nil target:target action:action];
}

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image titile:(NSString *)string fontSize:(CGFloat)fontSize leftOffSet:(CGFloat)offSet backImg  :(UIImage *) backImg  target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 增加背景
    if(backImg){
        [button setBackgroundImage:backImg forState:UIControlStateNormal];
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:(UIEdgeInsets){0,offSet,0,0}];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleEdgeInsets:(UIEdgeInsets){0,-5,0,0}];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.height = 28;
    button.width = button.width-offSet+5;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setBadgeWithNumber:(NSInteger)integer withFont:(UIFont *)font color:(UIColor *)color
{
    UIButton *button = (UIButton *)self.customView;
    
    UILabel *label = (UILabel *)[button viewWithTag:kBadgeViewTag];
    if (integer > 0){
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(button.right-8, 0, 16, 16)];
            [label setLabelWith:[NSString stringWithFormat:@"%ld",(long)integer] color:[UIColor whiteColor] font:font aliment:NSTextAlignmentCenter];
            label.backgroundColor = color;
            label.layer.cornerRadius = label.width/2.f;
            label.layer.masksToBounds = YES;
            label.clipsToBounds = YES;
            label.tag = kBadgeViewTag;
            [label adjustsFontSizeToFitWidth];
            [button addSubview:label];
        }
        label.text = [NSString stringWithFormat:@"%ld",(long)integer];
    }else
    {
        if (label) {
            label.hidden = YES;
            [label removeFromSuperview];
        }
    }
}

@end
