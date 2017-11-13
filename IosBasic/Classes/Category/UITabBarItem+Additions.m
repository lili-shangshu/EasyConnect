//
//  UITabBarItem+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UITabBarItem+Additions.h"

@implementation UITabBarItem (Additions)

+ (void)setDefaultItemTextType
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:10.f]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateSelected];
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:selectedImage];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                   NSFontAttributeName : [UIFont defaultTextFontWithSize:11.f],
                                   } forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSFontAttributeName : [UIFont defaultTextFontWithSize:11.f],
                                   } forState:UIControlStateHighlighted];
//
    //    item.imageInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    //    item.titlePositionAdjustment =  UIOffsetMake(0, 0);
    
    return item;
}

@end
