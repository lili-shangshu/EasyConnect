//
//  SMDProgressView.m
//  Sanmeditech
//
//  Created by Nathan on 14-5-28.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import "NAProgressHUD.h"
#import "NATools+Headers.h"

static NAProgressHUD *hudView = nil;

@implementation NAProgressHUD

+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

+ (instancetype)hudView
{
    return [NAProgressHUD hudViewWithBackground:YES];
}

+ (instancetype)hudViewWithBackground:(BOOL)withBg
{
    if (!hudView) {
        UIWindow *keyWindow = [self keyWindow];
        
        hudView = [[NAProgressHUD alloc] initWithFrame:CGRectMake(0, 0, keyWindow.width, keyWindow.height)];
        
        UIView *backgroundView;
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [backgroundView setAlpha:0.89f];
        backgroundView.hidden = !withBg;
        backgroundView.layer.cornerRadius = 5.f;
        backgroundView.layer.masksToBounds = YES;
        hudView.backgroundView = backgroundView;
        
//        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [loadingView setFrame:CGRectMake(keyWindow.width / 2 - 45 / 2, keyWindow.height / 2 - 45 / 2, 45, 45)];
//        hudView.indicator = loadingView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading1"]];
        imageView.size = CGSizeMake(50, 50);
        imageView.center = keyWindow.center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.alpha = 0.8f;
        imageView.layer.masksToBounds = YES;
        [self rotateView:imageView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, keyWindow.width, 22)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel sizeToFit];
        textLabel.top = imageView.bottom+10.f;
        [textLabel centerAlignHorizontalForView:hudView];
        hudView.textLabel = textLabel;
        
        backgroundView.center = imageView.center;
        
        if (backgroundView) [hudView addSubview:backgroundView];
        [hudView addSubview:imageView];
        [hudView addSubview:textLabel];
        [hudView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
    }
    return hudView;
}

+ (void)showHUD
{
    [NAProgressHUD showHUDWithText:nil];
}

+ (void)rotateView:(UIView *)view
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.85;
    rotationAnimation.RepeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"RotationKey"];
}

+ (void)showHUDWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NAProgressHUD *hudView = [self hudView];
        hudView.textLabel.text = text;
        [hudView.textLabel sizeToFit];
        
        // 调整位置
        hudView.textLabel.top = hudView.indicator.bottom+10.f;
        [hudView.textLabel centerAlignHorizontalForView:hudView];
        
        hudView.backgroundView.width = hudView.backgroundView.width-10.f>=hudView.textLabel.width?hudView.backgroundView.width:hudView.textLabel.width+10.f;
        hudView.backgroundView.height = hudView.backgroundView.width;
        hudView.backgroundView.center = CGPointMake(hudView.textLabel.x, hudView.indicator.bottom );
        
        hudView.textLabel.hidden = NO;
        hudView.backgroundView.hidden = NO;
        hudView.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [hudView.indicator startAnimating];
        
        [[self keyWindow] addSubview:hudView];
        [[self hudView] setHidden:NO];
        [[self hudView] setAlpha:0];
        [UIView animateWithDuration:0.2f animations:^{
            [[self hudView] setAlpha:1];
        }];
    });
}

+ (void)showHUDWithOnlyActivaty
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NAProgressHUD *hudView = [self hudViewWithBackground:NO];
        [hudView.indicator startAnimating];
        hudView.textLabel.hidden = YES;
        hudView.backgroundView.hidden = NO;
        hudView.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        [[self keyWindow] addSubview:hudView];
        [[self hudView] setHidden:NO];
        [[self hudView] setAlpha:0];
        [UIView animateWithDuration:0.2f animations:^{
            [[self hudView] setAlpha:1];
        }];
    });
}

+ (void)hideHUD
{
    [self hideHUDWithCompletion:nil];
}

+ (void)hideHUDWithCompletion:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2f animations:^{
            [[self hudView] setAlpha:0];
        } completion:^(BOOL finished) {
            [[self hudView] removeFromSuperview];
            [[self hudView] setHidden:YES];
            hudView = nil;
            if (block) block();
        }];
    });
}

+ (void)showHUDWithText:(NSString *)text whileExecutingBlock:(void(^)())block completion:(void(^)())completentBlock
{
    [self showHUDWithText:text];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self hideHUD];
            completentBlock();
        });
    });
}

+ (void)showHUDWithText:(NSString *)text executingBackgroundBlock:(void(^)(dispatch_group_t tempGroup))block completion:(void(^)())completion
{
    [self showHUDWithText:text];
    
    dispatch_group_t tempGroup = dispatch_group_create();
    
    dispatch_group_enter(tempGroup);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        block(tempGroup);
    });
    
    dispatch_group_notify(tempGroup, dispatch_get_global_queue(0, 0), ^{
        usleep(1*1000*1000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            completion();
        });
    });
    
}

+ (NSTimer *)addTimeOutOperationWithInterval:(CGFloat)interval completionBlock:(void (^)())completentBlock
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(completionWithTimer:) userInfo:completentBlock repeats:NO];
    return timer;
}

+ (void)completionWithTimer:(NSTimer *)timer
{
    void (^completionBlock)();
    completionBlock = timer.userInfo;
    completionBlock();
}

@end
