//
//  SMDProgressView.h
//  Sanmeditech
//
//  Created by Nathan on 14-5-28.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAProgressHUD : UIView

/*
 有什么特别？
 1. 可以自定义等待的View
 2. 可以直接编辑等待的动作的block
 3. 直观，稳定
 */

// 还没具体开始弄这个

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Editable When is not a custom HUD View
////////////////////////////////////////////////////////////////////////////////////

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *shedowView;

////////////////////////////////////////////////////////////////////////////////////

@property (nonatomic, strong) UIView *customHUDView; // 自定义的等待页面

+ (void)showHUD;
+ (void)showHUDWithText:(NSString *)text;
+ (void)showHUDWithOnlyActivaty;
+ (void)hideHUD;
+ (void)hideHUDWithCompletion:(void(^)())block;

+ (void)showHUDWithText:(NSString *)text whileExecutingBlock:(void(^)())block completion:(void(^)())completentBlock;

+ (void)showHUDWithText:(NSString *)text executingBackgroundBlock:(void(^)(dispatch_group_t tempGroup))block completion:(void(^)())completion;

+ (NSTimer *)addTimeOutOperationWithInterval:(CGFloat)interval completionBlock:(void(^)())completentBlock;

@end
