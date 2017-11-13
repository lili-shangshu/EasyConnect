//
//  FGShareSheet.h
//  FlyGift
//
//  Created by Nathan Ou on 15/1/7.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGShareSheet : UIView

@property (nonatomic, strong) void(^timeLineAction)();
@property (nonatomic, strong) void(^qZoneAction)();
@property (nonatomic, strong) void(^QQAction)();
@property (nonatomic, strong) void(^weChatAction)();
@property (nonatomic, strong) void(^facebookAction)();
@property (nonatomic, strong) void(^whatsappAction)();
@property (nonatomic, strong) void(^weChatBothAction)();

@property (nonatomic, strong) void(^cancelActionBlock)();

- (void)show;
- (void)showWithCompletion:(void(^)())block;
- (void)hide;
- (void)hideWithCompletion:(void(^)())block;

@end
