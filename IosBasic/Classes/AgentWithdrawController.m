//
//  AgentApplyController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "AgentWithdrawController.h"
#import "SPNetworkManager.h"
#import <PSPDFActionSheet.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#import <CTAssetsPickerController.h>
#import "NACTPageViewController.h"
#import "NAEmotionsView.h"
#import <Reachability.h>
#import "OTAvatarImagePicker.h"
#import "NATextField.h"


@interface AgentWithdrawController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *unionBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet NATextField *accountField;
@property (weak, nonatomic) IBOutlet NATextField *yearField;
@property (weak, nonatomic) IBOutlet NATextField *monthField;
@property (weak, nonatomic) IBOutlet UILabel *validateLbl;

@property (nonatomic,assign) int payMethod;

@end

@implementation AgentWithdrawController

- (void)viewDidLoad {
     [super viewDidLoad];
    
     [self addBackgroundTapAction];
    
    _payMethod= 1;
    
    _unionBtn.layer.borderWidth = 1;
    _aliBtn.layer.borderWidth = 1;
    _wechatBtn.layer.borderWidth = 1;
    _unionBtn.layer.borderColor = [[UIColor spThemeColor] CGColor];
    _aliBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    _wechatBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _nameField.delegate = self;
    _accountField.delegate = self;
    _yearField.delegate = self;
    _monthField.delegate = self;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundTapAction:) name:kSPHideKeyboard object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];

}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    _payMethod = tag+1;
    
    // 银联
    if(tag == 0){
        _unionBtn.layer.borderColor = [[UIColor spThemeColor] CGColor];
        _aliBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _wechatBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        _validateLbl.hidden = NO;
        _yearField.hidden = NO;
        _monthField.hidden = NO;
    }else if(tag ==1){
     // 支付宝
        _unionBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _aliBtn.layer.borderColor = [[UIColor spThemeColor] CGColor];
        _wechatBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        _validateLbl.hidden = YES;
        _yearField.hidden = YES;
        _monthField.hidden = YES;
        
    }else if(tag == 2){
     // 微信
        _unionBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _aliBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _wechatBtn.layer.borderColor = [[UIColor spThemeColor] CGColor];
        
        _validateLbl.hidden = YES;
        _yearField.hidden = YES;
        _monthField.hidden = YES;
    }
    
    
}



- (IBAction)registAction:(id)sender {
    
    //统一收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    if([_moneyField.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"提现金额不能为空"];
        return;
    }else{
    
        if([_moneyField.text floatValue] > [_money floatValue]){
            [SVProgressHUD showInfoWithStatus:@"提现金额超过可提现金额"];
            return;
        }
    
    }
    
    
    if([_nameField.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"姓名不能为空"];
        return;
    }
    
    if([_accountField.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"账号不能为空"];
        return;
    }
    
    if(_payMethod==1){
    
        if([_yearField.text isEmptyString]){
            [SVProgressHUD showInfoWithStatus:@"有效期-年分不能为空"];
            return;
        }
        
        if([_monthField.text isEmptyString]){
            [SVProgressHUD showInfoWithStatus:@"有效期-月份不能为空"];
            return;
        }
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{m_id:self.currentMember.id,
                                                                               m_member_user_shell:self.currentMember.memberShell}];
    [dic setObject:_moneyField.text forKey:@"txje"];
    [dic setObject:_nameField.text forKey:@"ckr"];
    [dic setObject:_accountField.text forKey:@"yhkh"];
    [dic setObject:_yearField.text forKey:@"year"];
    [dic setObject:_monthField.text forKey:@"month" ];
    NSString *method = [NSString stringWithFormat:@"%d", _payMethod];
    [dic setObject:method forKey:@"zffs"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SPNetworkManager sharedClient] applyWithdrawWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
        
        if (succeeded) {
            
            [SVProgressHUD showInfoWithStatus:@"提现申请提交成功"];
        }
    }];

    
    
}

- (void)backgroundTapAction:(id)sensor
{
    [self hideKeyBoard];
    self.view.frame = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

#pragma mark---UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textField convertRect: textField.bounds toView:window];
    
        int offset = frame.origin.y + 10 - (self.view.frame.size.height - 216.0);//键盘高度216
    
   // int offset = frame.origin.y + 38 - (self.view.frame.size.height - 252.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end

