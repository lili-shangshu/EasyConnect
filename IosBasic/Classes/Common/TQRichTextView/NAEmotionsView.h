//
//  NAEmotionsView.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/24.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FGBottomBarComplitionBlock)(UIView *bottomBar);

@protocol NAEmotionsDelegate <NSObject>

- (void)emotionViewWillShowWithHeight:(CGFloat)height animationDruation:(CGFloat)druation;
- (void)emotionViewWillHideWithDruation:(CGFloat)druation;
- (void)emotionViewDeleteButtonDidTap:(UIButton *)deleteButton;
- (void)didAddEmotion:(NSString *)emotion;

@end

@interface NAEmotionsView : UIView

@property (nonatomic, assign) BOOL isShown;
@property (nonatomic, strong) id <NAEmotionsDelegate> delegate;
@property (nonatomic, strong) NSArray *emotionArray;

+ (instancetype)shareView;

- (void)showBottomBarWithAnimation:(BOOL)animated;
- (void)showBottomBarWithAnimation:(BOOL)animated completion:(FGBottomBarComplitionBlock)block;
- (void)hideBottomBarWithAnimation:(BOOL)animated;
- (void)hideBottomBarWithAnimation:(BOOL)animated completion:(FGBottomBarComplitionBlock)block;

- (void)isEmotionStringAtLastWithString:(NSString *)string withDetectBlock:(void(^)(BOOL isEmotion, NSRange currentRange, NSString *emotionStr))block;

@end
