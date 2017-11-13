//
//  UIView+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-11-9.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NATools)

- (void)hideExtraCellHide;

+ (instancetype)NA_ItemsViewWithPadding:(CGFloat)padding Views:(UIView *)firstView, ... NS_REQUIRES_NIL_TERMINATION;

// 画线用的，长度的说明是横线，高度的说明是竖线
+ (UIImageView *)lineViewWithWidth:(CGFloat)width yPoint:(CGFloat)yPoint withColor:(UIColor *)color;
+ (UIImageView *)lineDashTypeWithWidth:(CGFloat)width yPoint:(CGFloat)yPoint withColor:(UIColor *)color;
+ (UIImageView *)dashlineWithHeight:(CGFloat)height xPoint:(CGFloat)xPoint withColor:(UIColor *)color;
+ (UIView *)shadowLineViewWidth:(CGFloat)width yPoint:(CGFloat)yPoint;
+ (UIImageView *)lineWithHeight:(CGFloat)height xPoint:(CGFloat)xPoint withColor:(UIColor *)color;

/// TableView Zero Insets
- (void)tableviewSetZeroInsets;
- (void)cellSetZeroInsets;

// 设置View的圆角，会把clipToBounds设成Yes
- (void)addCornerRadius:(CGFloat)radius;

@end
