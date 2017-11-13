//
//  UIViewController+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/4.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPMember;
@class SPMainTabBarController;

@interface UIViewController (Additions)

- (UIBarButtonItem *)backButton;
- (void)addBackButtonWithImage:(UIImage *)image;
- (void)addBackButton;
- (void)backBarButtonPressed:(id)backBarButtonPressed;
- (UIWindow *)mainWindow;
- (UITabBarController *)mainTabBarController;
- (void)setMainTabBarController:(SPMainTabBarController *)controller;

- (SPMember *)currentMember;

- (void)presentWithController:(UIViewController *)controller;

@end
