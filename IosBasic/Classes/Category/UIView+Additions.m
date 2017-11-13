//
//  UIView+Additions.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/17.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "UIView+Additions.h"
#import <objc/runtime.h>

#define kShadowCoverTag 123443

static NSString *const kActionKey = @"kActionKey";

@interface UIView()

@property (nonatomic, strong) void(^actionBlock)();

@end

@implementation UIView (Additions)

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Propeties
////////////////////////////////////////////////////////////////////////////////////

- (void (^)())actionBlock
{
    return objc_getAssociatedObject(self, &kActionKey);
}

- (void)setActionBlock:(void (^)())actionBlock
{
    objc_setAssociatedObject(self, &kActionKey, actionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addShadowCoverWithAlpha:(CGFloat)alpha withTouchAction:(void (^)())block
{
    UIView *shadowView = [self viewWithTag:kShadowCoverTag];
    if (!shadowView) {
        shadowView = [[UIView alloc] initWithFrame:self.bounds];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        if (block) self.actionBlock = block;
        [button addTarget:self action:@selector(shadowViewGotTap) forControlEvents:UIControlEventTouchUpInside];
        button.frame = shadowView.bounds;
        [shadowView addSubview:button];
    }
    shadowView.tag = kShadowCoverTag;
    shadowView.backgroundColor = [UIColor grayColor];
    shadowView.alpha = 0;
    shadowView.hidden = NO;
    [self addSubview:shadowView];
    
    [UIView animateWithDuration:0.2 animations:^{
        shadowView.alpha = alpha;
    }];
}

- (void)shadowViewGotTap
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)hideShadow
{
    [self hideShadowAnimated:YES];
}

- (void)hideShadowAnimated:(BOOL)animated
{
    [self hideShadowAnimated:animated withDuration:0.2];
}

- (void)hideShadowAnimated:(BOOL)animated withDuration:(CGFloat)duration
{
    UIView *shadowView = [self viewWithTag:kShadowCoverTag];
    if (shadowView) {
        if (animated) {
            [UIView animateWithDuration:duration animations:^{
                shadowView.alpha = 0;
            } completion:^(BOOL finished){
                shadowView.hidden = YES;
            }];
        }else{
            shadowView.hidden = YES;
        }
    }
}

@end
