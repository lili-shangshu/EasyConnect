//
//  NAGetCodeButton.h
//  IosBasic
//
//  Created by junshi on 16/3/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NAGetSubmitCodeButton
////////////////////////////////////////////////////////////////////////////////////

@interface NAGetCodeButton : UIButton

@property (nonatomic, assign) NSInteger countSecond;

@property (nonatomic, assign) BOOL isCounting;
@property (nonatomic, assign) NSInteger currentCountingNumber;
@property (nonatomic, strong) NSTimer *countingTimer;
@property (nonatomic, strong) void(^completionBlock)();

@property (nonatomic, strong) UIColor *buttonEnableColor;
@property (nonatomic, strong) UIColor *buttonDisableColor;
@property (nonatomic, strong) UIColor *enableTitleColor;
@property (nonatomic, strong) UIColor *disableTitleColor;
@property (nonatomic, strong) NSString *title;

- (void)stopCounting;
- (void)getSubmitCodeWithAction:(void(^)())block completeCounting:(void(^)())completion;

@end

////////////////////////////////////////////////////////////////////////////////////
