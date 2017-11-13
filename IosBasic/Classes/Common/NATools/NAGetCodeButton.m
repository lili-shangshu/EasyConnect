//
//  NAGetCodeButton.m
//  IosBasic
//
//  Created by junshi on 16/3/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NAGetCodeButton.h"

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - FGGetSubmitCodeButton
////////////////////////////////////////////////////////////////////////////////////

@interface NAGetCodeButton ()

@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;

@end

@implementation NAGetCodeButton

- (id)init;
{
    self = [NAGetCodeButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.countSecond = 60.f;
        self.isCounting = NO;
     
        self.buttonEnableColor = [UIColor spThemeColor];
        self.buttonDisableColor = [UIColor lightGrayColor];
        self.disableTitleColor = [UIColor whiteColor];
        self.enableTitleColor = [UIColor whiteColor];
        
        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:self.disableTitleColor forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.backgroundColor = self.buttonDisableColor;
        self.layer.cornerRadius = 0.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

- (void)setButtonEnableColor:(UIColor *)buttonEnableColor
{
    _buttonEnableColor = buttonEnableColor;
    if (self.enabled) {
        self.backgroundColor = buttonEnableColor;
    }
}

- (void)setButtonDisableColor:(UIColor *)buttonDisableColor
{
    _buttonDisableColor = buttonDisableColor;
    if (!self.enabled) {
        self.backgroundColor = buttonDisableColor;
    }
}

- (UIColor *)disableTitleColor
{
    if (!_disableTitleColor) {
        _disableTitleColor = [UIColor whiteColor];
    }
    return _disableTitleColor;
}

- (UIColor *)enableTitleColor
{
    if (!_enableTitleColor) {
        _enableTitleColor = [UIColor whiteColor];
    }
    return _enableTitleColor;
}

- (void)getSubmitCodeWithAction:(void (^)())block completeCounting:(void (^)())completion
{
    self.isCounting = YES;
    self.currentCountingNumber = self.countSecond;
    self.enabled = NO;
    
    if (block) {
        block();
    }
    
    if (!self.countingTimer) {
        self.countingTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(counting) userInfo:nil repeats:YES];
    }
    
}

- (void)counting
{
    self.currentCountingNumber--;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateButtonTitle];
    });
    
    if (self.currentCountingNumber <= 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.countingTimer) {
                [self.countingTimer invalidate];
                self.countingTimer = nil;
            }
            [self finishCounting];
            
        });
    }
}

- (void)stopCounting
{
    if (self.isCounting) {
        if (self.countingTimer) {
            [self.countingTimer invalidate];
            self.countingTimer = nil;
        }
        [self setTitle:self.title forState:UIControlStateNormal];
        self.isCounting = NO;
        self.enabled = YES;
    }
}

- (void)updateButtonTitle
{
    [self setTitle:[NSString stringWithFormat:@"%ld S",(long)self.currentCountingNumber] forState:UIControlStateDisabled];
}

- (void)finishCounting
{
    self.isCounting = NO;
    [self setTitle:self.title forState:UIControlStateNormal];
    self.enabled = YES;
    if (self.completionBlock) {
        self.completionBlock();
    }
}

-(void)dealloc
{
    if (self.countingTimer) {
        [self.countingTimer invalidate];
        self.countingTimer = nil;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled) {
        [self setTitleColor:self.enableTitleColor forState:UIControlStateNormal];;
        [self setBackgroundColor:self.buttonEnableColor];
    }else{
        [self setTitleColor:self.disableTitleColor forState:UIControlStateNormal];;
        [self setBackgroundColor:self.buttonDisableColor];
    }
}

@end


