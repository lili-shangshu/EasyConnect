//
//  UITabBarItem+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (Additions)

+ (void)setDefaultItemTextType;
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
