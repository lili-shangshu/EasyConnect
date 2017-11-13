//
//  SPSignUpController.m
//  StraightPin
//
//  Created by Nathan Ou on 15/3/11.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPModifyPwController.h"

#import "SPNetworkManager.h"
#import "SVProgressHUD.h"

#define kPadding 25.f


#define kSummitCode @"输入当前密码"
#define kPassword @"输入新密码"
#define kRePasswrod @"再次输入新密码"

#define kSummitButton @"确认密码"

#define kLabel1Height 22.f
#define kLabel2Height 26.f
#define kSignUpMobileCellHeight kPadding+kLabel1Height+kLabel2Height

@interface SPModifyPwController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UITextField *oldPasswordTF;
@property (nonatomic, strong) UITextField *newsPasswordTF;
@property (nonatomic, strong) UITextField *reNewPasswordTF;

//@property (nonatomic, strong) UITextField *submitCodeTF;

//@property (nonatomic, strong) NAGetCodeButton *codeButton;

@end

@implementation SPModifyPwController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    self.titles = @[kSummitCode,kPassword,kRePasswrod,kSummitButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.height = self.view.height - kTransulatInset;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView hideExtraCellHide];
    [self.view addSubview:self.tableView];
    
    [self addBackgroundTapAction];
    
    [self addBackButton];
    self.inNavController = YES;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////

- (void)buttonAction:(id)sender
{
    
    [self.oldPasswordTF resignFirstResponder];
    [self.newsPasswordTF resignFirstResponder];
    [self.reNewPasswordTF resignFirstResponder];
    
    if ([self.oldPasswordTF isTextFieldEmpty]) {
        [SVProgressHUD showInfoWithStatus:@"请输入当前密码"];
        return;
    }
    
    if ([self.newsPasswordTF isTextFieldEmpty]) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    
    if ([self.reNewPasswordTF isTextFieldEmpty]) {
        [SVProgressHUD showInfoWithStatus:@"请重复输入密码"];
        return;
    }
    
    if (![self.newsPasswordTF.text isEqualToString:self.reNewPasswordTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入的密码不一致"];
        return;
    }
    
    if (self.newsPasswordTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"请输入6位以上的密码"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
//    [[SPNetworkManager sharedClient] resetPassword:self.passwordTF.text rePw:self.rePasswordTF.text moblie:self.currentMember.username authoCode:self.submitCodeTF.text completin:^(BOOL succeeded, id responseObject ,NSError *error){
//        if (succeeded) {
//            [NADefaults sharedDefaults].password = self.passwordTF.text;
//            [iToast showToastWithText:@"修改密码成功" position:iToastGravityBottom];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            
//        }
//        [SVProgressHUD dismiss];
//    }];
    
    NSDictionary *dic = @{mC_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          @"oldpwd":self.oldPasswordTF.text,
                          @"newpwd":self.newsPasswordTF.text,
                          m_editType:@"password"};
    [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {

        if (succeeded) {
            [NADefaults sharedDefaults].password = self.newsPasswordTF.text;

            [SVProgressHUD showInfoWithStatus:@"修改密码成功,请重新登录"];
            
            [NADefaults sharedDefaults].password = nil;
            [NADefaults sharedDefaults].currentMemberId  = nil;
            NAPostNotification(kSPLoginStatusChanged, nil);
            NAPostNotification(kSPShopCartChange, nil);     // 更新角标
        
            [self.navigationController popViewControllerAnimated:YES];

        }
    }];
}

- (void)submitCodeButtonAction:(id)sender
{
//    NAGetCodeButton *button = (NAGetCodeButton *)sender;
//    
//    [self backgroundTapAction:nil];
//    
//    [button getSubmitCodeWithAction:^{
//        [[SPNetworkManager sharedClient] getValidateCodeWithMoblie:self.currentMember.username type:SPValidateCodeType_Forgot completion:^(BOOL succeeded, id responseObject ,NSError *error){
//            if (succeeded) {
//                
//            }else
//            {
//                [button stopCounting];
//            }
//        }];
//    } completeCounting:^{
//        
//    }];
}

- (void)backgroundTapAction:(id)sensor
{
    [self.oldPasswordTF resignFirstResponder];
    [self.newsPasswordTF resignFirstResponder];
    [self.reNewPasswordTF resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)textViewWithString:(NSString *)string frame:(CGRect)frame
{
    CGFloat padding = (frame.size.height-30)/2.f;
    
    // 这个是外面的框
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [UIColor spLineColor].CGColor;
    view.layer.masksToBounds = YES;
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(padding, padding, view.width-padding*2, 30)];
    field.backgroundColor = [UIColor clearColor];
    field.placeholder = string;
    [view addSubview:field];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return @[view,field];
}

//- (NAGetCodeButton *)codeButton
//{
//    if (!_codeButton) {
//        _codeButton = [[NAGetCodeButton alloc] init];
//    }
//    return _codeButton;
//}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate & DataSource
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadding+kDefautCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.titles[indexPath.row];
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
    }else
        return cell;
    
    CGFloat horizontalPadding =45.f;
    
    if ([title isEqualToString:kPassword] || [title isEqualToString:kRePasswrod] || [title isEqualToString:kSummitCode]) {
        
        NSArray *views = [self textViewWithString:title frame:CGRectMake(horizontalPadding, kPadding, self.view.width-horizontalPadding*2, kDefautCellHeight)];
        UIView *textView = views[0];
        if ([title isEqualToString:kPassword]) {
            self.newsPasswordTF = views[1];
            self.newsPasswordTF.secureTextEntry = YES;
            self.newsPasswordTF.delegate = self;
        }
        if ([title isEqualToString:kRePasswrod]) {
            self.reNewPasswordTF = views[1];
            self.reNewPasswordTF.secureTextEntry = YES;
            self.reNewPasswordTF.delegate = self;
        }
        if ([title isEqualToString:kSummitCode]) {
            self.oldPasswordTF = views[1];
            self.oldPasswordTF.secureTextEntry = YES;
            self.oldPasswordTF.delegate = self;
        }
        [cell.contentView addSubview:textView];
    }
    
    if ([title isEqualToString:kSummitButton]) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        
        UIButton *button = [UIButton NA_RoundRectButtonWithTitle:title backgroundColor:[UIColor gray1] cornerRadius:kNARoundRectRadius];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
        button.frame = CGRectMake(horizontalPadding, kPadding, self.view.width-horizontalPadding*2, kDefautCellHeight-10);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TextFieldDelegate
////////////////////////////////////////////////////////////////////////////////////

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE6 || IS_IPHONE6_PLUS) return;
    CGFloat animaitedHeight = 50.f;
    if ([textField.placeholder isEqualToString:kRePasswrod]) animaitedHeight = 120.f;
    if (IS_IPHONE5) {
        if ([textField.placeholder isEqualToString:kRePasswrod]) {
            animaitedHeight = 50.f;
        }else
            return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.top = -animaitedHeight;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.tableView.top < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.top = 0;
        }];
    }
}

@end
