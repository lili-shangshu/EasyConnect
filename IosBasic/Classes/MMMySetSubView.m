//
//  MMMySetSubView.m
//  IosBasic
//
//  Created by Star on 2017/6/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "MMMySetSubView.h"
#import "SPNetworkManager.h"
#import "UIView+TYAlertView.h"

@interface MMMySetSubView()<UITextFieldDelegate>

@end

@implementation MMMySetSubView

-(void)initWithFrame:(CGRect)frame WithType:(NSInteger)typeNum{
    if ([super initWithFrame: frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.f;
        self.titleLable.text = @"输入充值金额";
        self.textFiled.delegate = self;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)cancleButtonClicked:(id)sender {
    [self hideView];
}
- (IBAction)confirmButtonClicked:(id)sender {
    if ([self.textFiled.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"请输入"];
        return;
    }
    self.confirmButtonBlock(self.textFiled.text);
    [self hideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
