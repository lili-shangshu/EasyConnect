//
//  RegisterOneController.m
//  IosBasic
//
//  Created by li jun on 16/11/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "RegisterOneController.h"
#import "NAGetCodeButton.h"

#define ktelephone @"请输入手机号"
#define kcode @"请输入手机验证码"
#define kpwd1 @"设置密码"
#define kpwd2 @"确认密码"
#define kpwd3 @"6-20位数字／字母／符号"
#define kregister @"注册"
#define kconfirm @"点击注册表示同意《用户协议》"
#define kblank @"kong"

#define cellHeight 50.f
#define blackHeight 10.f
#define textfont 15.f

@interface RegisterOneController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UITextField *telephoneTextField;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UITextField *pwdTextField;
@property(nonatomic,strong)UITextField *pwdTwoTextField;

@property (nonatomic,strong) NAGetCodeButton *scButton;


@end

@implementation RegisterOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight-kTabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.view addSubview:self.tableView];
    
    self.titleArray = @[kblank,ktelephone,kcode,kblank,kpwd1,kpwd2,kpwd3,kblank,kregister,kconfirm];
    
    
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:kblank]) {
        return blackHeight;
    }else{
        return cellHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:kblank]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kblank];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kblank];
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, blackHeight)];
        view.backgroundColor = [UIColor spBackgroundColor];
        [cell.contentView addSubview:view];
    }
    
    if ([title isEqualToString:ktelephone]||[title isEqualToString:kpwd1]||[title isEqualToString:kpwd2]) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-2*20, cellHeight)];
        cell = [tableView dequeueReusableCellWithIdentifier:title];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
            [textfield setBorderStyle:UITextBorderStyleNone];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            textfield.font = [UIFont defaultTextFontWithSize:14];
            textfield.textColor = [UIColor spLightGrayColor];
            
            textfield.placeholder = title;
            textfield.delegate = self;
            [cell.contentView addSubview:textfield];
            
            if ([title isEqualToString:ktelephone]) {
                self.telephoneTextField = textfield;
            }else if([title isEqualToString:kpwd1]){
                if (self.isfind) {
                    textfield.placeholder = @"重置密码";
                }
                textfield.secureTextEntry = YES;
                self.pwdTextField = textfield;
            }else{
                textfield.secureTextEntry = YES;
                self.pwdTwoTextField = textfield;
            }
        }
    }
    
    if ([title isEqualToString:kpwd3]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kpwd3];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kpwd3];
        }
        cell.backgroundColor = [UIColor spBackgroundColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-20, cellHeight)];
        lable.backgroundColor = [UIColor spBackgroundColor];
        lable.text = kpwd3;
        lable.font = [UIFont defaultTextFontWithSize:textfont-2];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lable];
    }
    
    if ([title isEqualToString:kcode]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kcode];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcode];
            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 150, cellHeight)];
            [textfield setBorderStyle:UITextBorderStyleNone];
            textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            textfield.font = [UIFont defaultTextFontWithSize:14];
            textfield.textColor = [UIColor spLightGrayColor];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.placeholder = title;
            textfield.delegate = self;
            self.codeTextField = textfield;
            [cell.contentView addSubview:textfield];
            
            NAGetCodeButton *scButton = [[NAGetCodeButton alloc] init];
            [scButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [scButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            scButton.titleLabel.font = [UIFont defaultTextFontWithSize:14];
            scButton.title = @"获取验证码";
            scButton.frame = CGRectMake(textfield.right+20, 10, 100, cellHeight-20);
            scButton.buttonEnableColor = [UIColor blackColor];
            scButton.enableTitleColor = [UIColor whiteColor];
            scButton.enabled = YES;
            scButton.countSecond = 30.f;
            scButton.layer.masksToBounds = YES;
            scButton.layer.cornerRadius = scButton.height/2;
            
            _scButton = scButton;
            [scButton addTarget:self action:@selector(CodebtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:scButton];
        }
    }
    
    if ([title isEqualToString:kregister]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kregister];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kregister];
        }
        cell.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-2*20, cellHeight)];
        if (self.isfind) {
             [button setTitle:@"确 定" forState:UIControlStateNormal];
        }else{
             [button setTitle:@"注  册" forState:UIControlStateNormal];
        }
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.f;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blackColor]];
        button.titleLabel.font = [UIFont defaultTextFontWithSize:textfont];
        [button addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    if ([title isEqualToString:kconfirm]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kconfirm];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kconfirm];
        }
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, cellHeight)];
        lable.backgroundColor = [UIColor spBackgroundColor];
        lable.text = kconfirm;
        lable.font = [UIFont defaultTextFontWithSize:textfont-1];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lable];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    self.view.backgroundColor = [UIColor spBackgroundColor];
    
}
#pragma mark -- UIbutton
- (void)CodebtnAction{
    [_scButton getSubmitCodeWithAction:^{} completeCounting:^{
        
    }];
}
- (void)registerButtonClicked{
    
    if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
        [iToast showToastWithText:@"请检查你的网络" position:iToastGravityBottom];
        return;
    }
    
    if ([self.telephoneTextField.text isEmptyString]) {
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空"];
        return;
    }
    
    if ([self.telephoneTextField.text isMobileNumber]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{m_phone :_telephoneTextField.text,
                                                                                  m_password : _pwdTextField.text,
                                                                                  m_sms_code : _codeTextField.text,
                                                                                  m_confirm_password : _pwdTwoTextField.text
                                                                                  }];
    if (self.isfind) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] findPasswordWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (succeeded) {
                [SVProgressHUD showInfoWithStatus:@"找回成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] signUpWithParams:params completion:^(BOOL succeeded, id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (succeeded) {
                [SVProgressHUD showInfoWithStatus:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
   
     NSLog(@"注册好了");
     NSLog(@"账号:%@ 验证码:%@ 密码 %@",self.telephoneTextField.text,self.codeTextField.text,self.pwdTextField.text);
    
   
}

#pragma mark---UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame=[textField convertRect: textField.bounds toView:window];
    
    //    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    int offset = frame.origin.y + 8 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.tableView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
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
    self.tableView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
