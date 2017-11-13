//
//  UINavigationController+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/2/28.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UINavigationController+Additions.h"
#import "UIColor+Additions.h"

@implementation UINavigationController (Additions)

- (void)applyAppDefaultApprence
{
    
    UINavigationBar *navigationBar = self.navigationBar;
    
    //设置导航栏颜色和字体
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                            NSFontAttributeName : [UIFont boldSystemFontOfSize:19.f],
                                            }];
    //设置返回按钮颜色
    navigationBar.tintColor = [UIColor whiteColor];

    
    //设置返回样式图片
//    UIImage *image = [UIImage imageNamed:@"navi_back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navigationBar.backIndicatorImage = image;
//    navigationBar.backIndicatorTransitionMaskImage = image;
    
    //偏移隐藏返回文字
//    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    UIOffset offset;
//    offset.horizontal = - 500;
//    offset.vertical =  - 500;
//    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];

    navigationBar.translucent = NO;
    
    [UINavigationController applyDefaultApprence];
}

+ (void)applyDefaultApprence
{
    // 设置导航栏背景色
    [[UINavigationBar appearance] setBackgroundImage:[[UIColor NA_ColorWithR:57 g:173 b:210] image]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
}

+ (void)setToDefaultApprence
{
    [[UINavigationBar appearance] setBackgroundImage:nil
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setLoginApprence
{
    UINavigationBar *navigationBar = self.navigationBar;
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                            NSFontAttributeName : [UIFont boldSystemFontOfSize:20.f],
                                            }];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor whiteColor];
    [[UITextView appearance] setTintColor:[UIColor black1]];
    navigationBar.translucent = NO;
    
    [UINavigationController applyDefaultApprence];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIColor whiteColor] image]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
