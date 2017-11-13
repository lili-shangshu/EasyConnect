//
//  UINavigationController+NATools.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/20.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (NATools)

- (void)pushViewController:(UIViewController *)viewController withRemovingController:(UIViewController *)reController animated:(BOOL)animated;


@end
