//
//  LoginViewController.m
//  IosBasic
//
//  Created by li jun on 17/4/11.
//  Copyright © 2017年 CRZ. All rights reserved.


#import "LoginViewController.h"
#import "SPNetworkManager.h"

@interface LoginViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%.1f== viewDidLoad===%.1f",self.view.frame.origin.y,self.view.frame.size.height);
    //    0.0== viewDidLoad===600.0=========1
    [self addBackgroundTapAction];
    
    if([NADefaults sharedDefaults].username){
        self.nameTextField.text =  [NADefaults sharedDefaults].username;
    }
    
    if([NADefaults sharedDefaults].password){
        self.passwordField.text =  [NADefaults sharedDefaults].password;
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backButtonClicked:(id)sender {
    if (self.loginResultBlock) {
        self.loginResultBlock(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)LoginButtonClicked:(id)sender {
    if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
        [SVProgressHUD showErrorWithStatus:@"请检查你的网络"];
        return;
    }

    if (KIsBlankString(self.nameTextField.text)) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    
    if (KIsBlankString(self.passwordField.text)) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *token = @"";
    if ([NADefaults sharedDefaults].deviceToken) {
        token = [NADefaults sharedDefaults].deviceToken;
    }
    
    NSDictionary *params = @{m_name : _nameTextField.text,
                             m_password : _passwordField.text,
                             @"os_type":@"ios",
                             m_ver:versionString,
                             m_udid:NAGetUDID(),
                             m_token:token
                             };
//    NSLog(@"登录信息%@",params);
//    if (self.loginResultBlock) {
//        self.loginResultBlock(YES);
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] loginWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            ECMemberObject *obj = responseObject;
            [SPMember saveECMember:obj];
            // 我天测试

            NAPostNotification(kSPShopCartChange, nil);

            [NADefaults sharedDefaults].username = _nameTextField.text;
            [NADefaults sharedDefaults].password = _passwordField.text;
            
            [NADefaults sharedDefaults].currentMemberId = obj.id;
            
            NAPostNotification(kSPLoginStatusChanged, nil);  // 更新首页
            
            [self updateDeviceToken];
            
            if (self.loginResultBlock) {
                self.loginResultBlock(YES);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD dismiss];
        }else{
            if (self.loginResultBlock) {
                  self.loginResultBlock(NO);
            }
        }
    }];
}

- (void)updateDeviceToken{
    
    SPMember *member = [SPMember currentMember];
    NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":member.id,m_member_user_shell:member.memberShell}];
    
    if([NADefaults sharedDefaults].deviceToken){
        [filterDictionary setObject:[NADefaults sharedDefaults].deviceToken forKey:@"deviceToken"];
        [[SPNetworkManager sharedClient] postTokenWithParams:filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
            if (succeeded){}else{}
        }];
        
    }
}
- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.nameTextField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
#pragma mark---textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)registerButtonClicked:(id)sender {
    NSLog(@"注册");
//    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (IBAction)forgetButtonClicked:(id)sender {
    NSLog(@"忘记密码");
//    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
//    registerVC.isfind = YES;
//    [self.navigationController pushViewController:registerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
