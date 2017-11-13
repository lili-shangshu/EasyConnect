//
//  RegisterViewController.m
//  IosBasic
//
//  Created by li jun on 17/4/12.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "CodeTextView.h"
#import "NAGetCodeButton.h"
#import "XWCountryCodeController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
// 以下是需要动态隐藏的部分
@property (weak, nonatomic) IBOutlet UILabel *emailLable;
@property (weak, nonatomic) IBOutlet UIView *emailLine;

@property (weak, nonatomic) IBOutlet UILabel *nickLable;
@property (strong, nonatomic) IBOutlet UIView *nickLine;

@property (weak, nonatomic) IBOutlet UIButton *countryButton;

//@property(nonatomic,strong)CodeTextView *codeView;

@property(nonatomic,strong)NAGetCodeButton *scBUtton;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addBackgroundTapAction];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NAGetCodeButton *scButton = [[NAGetCodeButton alloc] init];
    scButton.frame = CGRectMake(self.codeTextField.right+10, self.telephoneTextField.bottom+25, 100, 30);
    [scButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    scButton.titleLabel.font = [UIFont defaultTextFontWithSize:14];
    scButton.title = @"获取验证码";
    
    scButton.buttonEnableColor = [UIColor blackColor];
    scButton.enableTitleColor = [UIColor whiteColor];
    scButton.enabled = YES;
    scButton.countSecond = 60.f;
    scButton.layer.masksToBounds = YES;
    scButton.layer.cornerRadius = scButton.height/2;
    
    _scBUtton = scButton;
    [scButton addTarget:self action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scButton];
}

- (IBAction)countryCodeButtonClicked:(id)sender {
    
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
//    CountryCodeVC.deleagete = self;
    //block
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        [_countryButton setTitle: countryCodeStr forState:UIControlStateNormal];
    }];
    
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
    
    
}

// 二维码的设置
- (IBAction)codeButtonClicked:(id)sender {
    
    if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
        [iToast showToastWithText:@"请检查你的网络" position:iToastGravityBottom];
        return;
    }
    
    if ([self.telephoneTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    
    NSString *type = @"1";  // 1 注册 2找回密码
    if (self.isfind) {
        type = @"2";
    }
    NSMutableString *sting =[NSMutableString stringWithString:_countryButton.titleLabel.text];
    [sting deleteCharactersInRange:NSMakeRange(0, 1)];
    NSString *phone = [NSString stringWithFormat:@"%@%@",sting,_telephoneTextField.text];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{m_phone :phone,
                                                                                  @"typeNum" : type
                                                                                  }];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] sendMsgWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showInfoWithStatus:@"短信发送成功"];
            [_scBUtton getSubmitCodeWithAction:^{} completeCounting:^{
            
            }];
        }
    }];
    
    
}
- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
    [self.telephoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.pwdTwoTextField resignFirstResponder];

    
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonClicked:(id)sender {
    if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
        [iToast showToastWithText:@"请检查你的网络" position:iToastGravityBottom];
        return;
    }
    
    if ([self.telephoneTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    
    if (!_isfind) {
        if ([self.nickNameTextFiled.text isEmptyString]) {
            [SVProgressHUD showInfoWithStatus:@"昵称不能为空"];
            return;
        }
    }
    
    if ([self.codeTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        return;
    }
    
    if ([self.pwdTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    
    if (![self.pwdTwoTextField.text isEqualToString:self.pwdTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    
    if (self.pwdTextField.text.length < 6) {
        [iToast showToastWithText:@"请输入6位以上的密码" position:iToastGravityBottom];
        return;
    }
    
    NSMutableString *sting =[NSMutableString stringWithString:_countryButton.titleLabel.text];
    [sting deleteCharactersInRange:NSMakeRange(0, 1)];
    NSString *phone = [NSString stringWithFormat:@"%@%@",sting,_telephoneTextField.text];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{m_phone :phone,
                                                                                  m_password : _pwdTextField.text
                                                                                  }];
    if (!_isfind) {
        [params setObject:self.nickNameTextFiled.text forKey:@"nickName"];
        if (!KIsBlankString(self.emailTextField.text)) {
             [params setObject:self.emailTextField.text forKey:m_email];
        }
    }
    NSLog(@"注册信息：%@",params);
    if (_isfind) {
        [params setObject:_codeTextField.text forKey:@"sms_code"];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] findPasswordWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (succeeded) {
                [SVProgressHUD showInfoWithStatus:@"找回成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [params setObject:_codeTextField.text forKey:m_sms_code];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] signUpWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showInfoWithStatus:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [[SPNetworkManager sharedClient] signUpWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (succeeded) {
//            [SVProgressHUD showInfoWithStatus:@"注册成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];

    
//    NSLog(@"注册好了");
//    NSLog(@"账号:%@ 验证码:%@ 密码 %@",self.telephoneTextField.text,self.codeTextField.text,self.pwdTextField.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (_isfind) {
        // 使用以下代码，直接出线空白的页面！！！
        //        self.emailLable.hidden = YES;
        //        self.emailLine.hidden = YES;
        //        self.emailTextField.hidden = YES;
        
        //        self.invitationLable.hidden = YES;
        //        self.invitationLine.hidden = YES;
        //        self.invitationCodeTF.hidden = YES;
        
        [self.emailLable removeFromSuperview];
        [self.emailLine removeFromSuperview];
        [self.emailTextField removeFromSuperview];
        
        [self.nickLine removeFromSuperview];
        [self.nickLable removeFromSuperview];
        [self.nickNameTextFiled removeFromSuperview];
        
        [self.registerButton setTitle:@"确 定" forState:UIControlStateNormal ];
    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    _codeView = [[CodeTextView alloc] init];
//    _codeView.frame = CGRectMake(self.codeTextField.right+10, self.telephoneTextField.bottom+25, 100, 30);
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    [_codeView addGestureRecognizer:tap];
//    [self.view addSubview: _codeView];
//    
//    [self.view addSubview:_codeView];
//    
//}


//- (void)tapClick:(UITapGestureRecognizer*)tap
//{
//    [_codeView changeCode];
//    NSLog(@"labe%@",_codeView.changeString);
//}

#pragma mark---UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textField convertRect: textField.bounds toView:window];
    
    //    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    int offset = frame.origin.y + 38 - (self.view.frame.size.height - 252.0);//键盘高度216
    
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

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
