//
//  LoginViewController.m
//  IosBasic
//
//  Created by li jun on 17/4/11.
//  Copyright © 2017年 CRZ. All rights reserved.


#import "LoginViewController.h"
#import "RegisterController.h"
#import "SPNetworkManager.h"
#import "RegisterViewController.h"
#import "XWCountryCodeController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%.1f== viewDidLoad===%.1f",self.view.frame.origin.y,self.view.frame.size.height);
    //    0.0== viewDidLoad===600.0=========1
    [self addBackgroundTapAction];
    
    if([NADefaults sharedDefaults].username){
        self.nameTextField.text =  [NADefaults sharedDefaults].username;
        [self.countryButton setTitle:[NSString stringWithFormat:@"+%@",[NADefaults sharedDefaults].phone] forState:UIControlStateNormal];
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
        [iToast showToastWithText:@"请检查你的网络" position:iToastGravityBottom];
        return;
    }
    
    if ([self.nameTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空"];
        return;
    }
    if ([self.passwordField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //    NSDictionary *params = @{m_name : _nameTextField.text,
    //                             m_password : _passwordField.text,
    //                             @"os_type":@"ios",
    //                             m_ver:versionString,
    //                             m_udid:NAGetUDID(),
    //                             m_token:[NADefaults sharedDefaults].deviceToken
    //                             };
    NSString *token = @"";
    if ([NADefaults sharedDefaults].deviceToken) {
        token = [NADefaults sharedDefaults].deviceToken;
    }
    
    NSMutableString *sting =[NSMutableString stringWithString:_countryButton.titleLabel.text];
    [sting deleteCharactersInRange:NSMakeRange(0, 1)];
    NSString *phone = [NSString stringWithFormat:@"%@%@",sting,_nameTextField.text];
    
    NSDictionary *params = @{@"user_name" : phone,
                             m_password : _passwordField.text,
                             @"os_type":@"ios",
                             m_ver:versionString,
                             m_udid:NAGetUDID(),
                             m_token:token
                             };
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] loginWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            ECMemberObject *obj = responseObject;
             [SPMember saveECMember:obj];
            // 我天测试
           
            NAPostNotification(kSPShopCartChange, nil);
         
            [NADefaults sharedDefaults].username = _nameTextField.text;
            [NADefaults sharedDefaults].phone = sting;
            [NADefaults sharedDefaults].password = _passwordField.text;
            [NADefaults sharedDefaults].currentMemberId = obj.userId;
            
            // 需要从数据库汇总取值
            [NADefaults sharedDefaults].cartNumber = [obj.cartNumber integerValue];
            NAPostNotification(kSPLoginStatusChanged, nil);  // 更新我的页面信息
            NAPostNotification(kSPUpdateCarts, nil);    // 登录后更新购物车信息
            if (self.loginResultforName) {
                self.loginResultforName(obj.name);
            }
            
            if (self.loginResultBlock) {
                self.loginResultBlock(YES);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            if (self.loginResultBlock) {
                  self.loginResultBlock(NO);
            }
        }
        
    }];
}

- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.nameTextField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
- (IBAction)codeButtonClicked:(id)sender {
    // 登录时不需要这个参数。
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    //    CountryCodeVC.deleagete = self;
    //block
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        [_countryButton setTitle: countryCodeStr forState:UIControlStateNormal];
        //        _countryCode = countryCodeStr;
        // 登录时这个用不到
    }];
    
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
    
}

- (IBAction)registerButtonClicked:(id)sender {
    NSLog(@"注册");
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (IBAction)forgetButtonClicked:(id)sender {
    NSLog(@"忘记密码");
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.isfind = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)wechatButtonClicked:(id)sender {
     NSLog(@"微信");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"%.1f== viewWillAppear===%.1f",self.view.frame.origin.y,self.view.frame.size.height);
//    64.0== viewWillAppear===504.0========2
    
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
