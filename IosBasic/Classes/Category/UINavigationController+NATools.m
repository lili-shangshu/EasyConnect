//
//  UINavigationController+NATools.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/20.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UINavigationController+NATools.h"

@implementation UINavigationController (NATools)

- (void)pushViewController:(UIViewController *)viewController withRemovingController:(UIViewController *)reController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:YES];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [allViewControllers removeObjectIdenticalTo:reController];
    self.viewControllers = allViewControllers;
}


@end
