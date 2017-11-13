//
//  LoginController.m
//  IosBasic
//
//  Created by li jun on 16/11/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "SPNetworkManager.h"

#define LableHeight 50.f
#define ImageHeight 20.f

#define kUser @"用户名／邮箱／手机号"
#define kpassword @"请输入密码"

@interface LoginController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *passwordField;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, self.view.height-kNavigationHeight)];
    scrollView.backgroundColor = [UIColor spBackgroundColor];
    scrollView.contentSize = CGSizeMake(NAScreenWidth, NAScreenHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, NAScreenWidth, LableHeight*2)];
    loginView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:loginView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, ImageHeight, ImageHeight)];
    imageView.image = [UIImage imageNamed:@"ic_user"];
    [loginView addSubview:imageView];
    
    UITextField *nameT = [[UITextField alloc]initWithFrame:CGRectMake(imageView.right+20, 0, NAScreenWidth-3*20-imageView.width, LableHeight)];
    nameT.placeholder = kUser;
    nameT.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameT.autocorrectionType = UITextAutocorrectionTypeNo;
    nameT.delegate = self;
    if([NADefaults sharedDefaults].username){
        nameT.text =  [NADefaults sharedDefaults].username;
    }
    self.nameTextField = nameT;
    [loginView addSubview:nameT];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(nameT.left, LableHeight, NAScreenWidth, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [loginView addSubview:lineView];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, LableHeight+15, ImageHeight, ImageHeight)];
    imageView2.image = [UIImage imageNamed:@"ic_password"];
    [loginView addSubview:imageView2];
    
    UITextField *passwordT = [[UITextField alloc]initWithFrame:CGRectMake(imageView2.right+20, lineView.bottom, NAScreenWidth-3*20-imageView.width, LableHeight)];
    passwordT.secureTextEntry = YES;
    passwordT.placeholder = kpassword;
    passwordT.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordT.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordT.delegate = self;
    if([NADefaults sharedDefaults].password){
        passwordT.text =  [NADefaults sharedDefaults].password;
    }
    self.passwordField = passwordT;
    [loginView addSubview:passwordT];
 
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(20, loginView.bottom+LableHeight*0.8, NAScreenWidth-2*20, LableHeight-10)];
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor blackColor]];
    loginButton.titleLabel.font = [UIFont defaultTextFontWithSize:15.f];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.f;
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginButton];
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(20, loginButton.bottom, 80, LableHeight)];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton sizeToFit];
    forgetButton.right = loginButton.right;
    forgetButton.height = LableHeight;
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont defaultTextFontWithSize:15.f];
    [forgetButton addTarget:self action:@selector(forgetbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetButton];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, forgetButton.bottom+1.5*LableHeight, NAScreenWidth-2*20, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:lineView2];
    
    UILabel *thridlalbe = [[UILabel alloc]initWithFrame:CGRectMake((NAScreenWidth-125)/2, forgetButton.bottom+LableHeight, 125, LableHeight)];
    thridlalbe.textAlignment = NSTextAlignmentCenter;
    thridlalbe.alpha = 1.f;
    thridlalbe.text = @"第三方登录";
    thridlalbe.backgroundColor =[UIColor spBackgroundColor];
    thridlalbe.textColor = [UIColor grayColor];
    thridlalbe.font = [UIFont defaultTextFontWithSize:14.f];
    [scrollView addSubview:thridlalbe];
    
    UIButton *weixinButton = [[UIButton alloc]initWithFrame:CGRectMake(NAScreenWidth/5, thridlalbe.bottom,NAScreenWidth/5 , NAScreenWidth/5)];
    [weixinButton setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    [weixinButton addTarget:self action:@selector(thirdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    weixinButton.tag = 1;
    [scrollView addSubview:weixinButton];
    
    UIButton *weiboButton = [[UIButton alloc]initWithFrame:CGRectMake(NAScreenWidth*3/5, thridlalbe.bottom,NAScreenWidth/5 , NAScreenWidth/5)];
    [weiboButton setImage:[UIImage imageNamed:@"login_weibo"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(thirdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    weiboButton.tag = 2;
    [scrollView addSubview:weiboButton];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"登录";
    
    [self addBackgroundTapAction];
    [self addBackButtonWithImage:[UIImage imageNamed:@"loginCancelButton"]];
    self.view.backgroundColor = [UIColor spBackgroundColor];
    UIBarButtonItem *rightbtn = [UIBarButtonItem NA_BarButtonWithtitile:@"快速注册" target:self action:@selector(rightButtonclicked)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
}
#pragma mark---Uibutton
- (void)backBarButtonPressed:(id)backBarButtonPressed{
    if (self.loginResultBlock) {
        self.loginResultBlock(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightButtonclicked{
    NSLog(@"注册");
    RegisterController *registerVC = [[RegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)loginButtonClicked{
    
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
    
    NSDictionary *params = @{m_name : _nameTextField.text,
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
        
            //      NAPostNotification(NoticeLoginChange, nil);
            
            [NADefaults sharedDefaults].username = _nameTextField.text;
            
//            [NADefaults sharedDefaults].username = obj.nickName;
            
            [NADefaults sharedDefaults].password = _passwordField.text;
            [NADefaults sharedDefaults].currentMemberId = obj.userId;
            
            // 需要从数据库汇总取值
//            [NADefaults sharedDefaults].cartNumber = 6;  没意义了
             NAPostNotification(kSPLoginStatusChanged, nil);  // 更新我的页面信息
             NAPostNotification(kSPUpdateCarts, nil);    // 登录后更新购物车信息
            if (self.loginResultforName) {
                self.loginResultforName(obj.name);
            }
            
            if (self.loginResultBlock) {
                self.loginResultBlock(YES);
            }
             [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD dismiss];
        }
        
    }];
  
}
- (void)forgetbuttonClicked{
    NSLog(@"忘记密码");
    RegisterController *registerVC = [[RegisterController alloc]init];
    registerVC.isfind = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)thirdButtonClicked:(UIButton *)button{
    if (button.tag == 1) {
        NSLog(@"微信");
    }else if (button.tag == 2){
        NSLog(@"微博");
    }
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
