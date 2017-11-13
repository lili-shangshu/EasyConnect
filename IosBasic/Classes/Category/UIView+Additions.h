//
//  UIView+Additions.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/17.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)addShadowCoverWithAlpha:(CGFloat)alpha withTouchAction:(void (^)())block;

- (void)hideShadow;
- (void)hideShadowAnimated:(BOOL)animated;
- (void)hideShadowAnimated:(BOOL)animated withDuration:(CGFloat)duration;

@end
