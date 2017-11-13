//
//  UIViewController+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/4.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UIViewController+Additions.h"
#import "AppDelegate.h"

@implementation UIViewController (Additions)

- (UIBarButtonItem *)backButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
    [button setImage:[UIImage imageNamed:@"spBack"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    [button addTarget:self action:@selector(backBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.width = button.width;
    button.height = 44.f;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addBackButton
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[[self backButton]];
}

- (void)addBackButtonWithImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.width = button.width;
    button.height = 44.f;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button]];
}

- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWindow *)mainWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UITabBarController *)mainTabBarController
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).mainTabbarController;
}

- (void)setMainTabBarController:(SPMainTabBarController *)controller
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).mainTabbarController = controller;
}

- (SPMember *)currentMember
{
    return [SPMember currentMember];
}

- (void)presentWithController:(UIViewController *)controller
{
    UINavigationController *navigationCV = [[UINavigationController alloc] initWithRootViewController:controller];
    [navigationCV applyAppDefaultApprence];
    navigationCV.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:navigationCV animated:YES completion:nil];
}

@end
