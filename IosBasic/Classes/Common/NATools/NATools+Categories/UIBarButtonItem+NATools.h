//
//  UIBarButtonItem+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NANavigationBarPaddingSpaceItem [UIBarButtonItem NA_FixedSpaceItem:-10]

@interface UIBarButtonItem (NATools)

+ (instancetype)NA_FlexibleSpaceItem;
+ (instancetype)NA_FixedSpaceItem:(CGFloat)width;
+ (instancetype)NA_BarButtonWithtitile:(NSString *)string target:(id)target action:(SEL)action;
+ (instancetype)NA_BarButtonWithtitile:(NSString *)string titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image width:(float)width height:(float)height target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image  selectedImage:(UIImage *) selctedImage target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image backImg:(UIImage *) backImg target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image titile:(NSString *)string leftOffSet:(CGFloat)offSet  target:(id)target action:(SEL)action;

+ (instancetype)NA_BarButtonWithImage:(UIImage *)image titile:(NSString *)string fontSize:(CGFloat)fontSize leftOffSet:(CGFloat)offSet backImg  :(UIImage *) backImg target:(id)target action:(SEL)action;

- (void)setBadgeWithNumber:(NSInteger)integer;

@end
