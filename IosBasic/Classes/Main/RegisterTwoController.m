//
//  RegisterTwoController.m
//  IosBasic
//
//  Created by li jun on 16/11/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "RegisterTwoController.h"

#define kuser @"用户名"
#define kuser2 @"用户名为3-25位，可以包含英文和数字"
#define kpwd1 @"设置密码"
#define kpwd2 @"确认密码"
#define kpwd3 @"6-20位数字／字母／符号"
#define kmail @"邮箱地址"
#define kmail2 @"请输入邮箱地址"
#define kregister @"注册"
#define kconfirm @"点击注册表示同意《用户协议》"
#define kblank @"kong"

#define cellHeight 50.f
#define blackHeight 10.f
#define black2Height 25.f

#define textfont 15.f

@interface RegisterTwoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UITextField *userTextField;
@property(nonatomic,strong)UITextField *mailTextField;
@property(nonatomic,strong)UITextField *pwdTextField;
@property(nonatomic,strong)UITextField *pwdTwoTextField;
@end

@implementation RegisterTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight-kTabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.view addSubview:self.tableView];
    
    if (self.isfind) {
        self.titleArray =  @[kblank,kmail,kblank,kregister,kconfirm];
    }else{
        self.titleArray = @[kblank,kuser,kuser2,kpwd1,kpwd2,kpwd3,kmail,kmail2,kblank,kregister,kconfirm];
    }
    
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
    }else if ([title isEqualToString:kmail2]||[title isEqualToString:kpwd3]||[title isEqualToString:kuser2]){
        return black2Height;
    }
    else{
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
    
    if ([title isEqualToString:kuser]||[title isEqualToString:kpwd1]||[title isEqualToString:kpwd2]||[title isEqualToString:kmail]) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-2*20, cellHeight)];
        cell = [tableView dequeueReusableCellWithIdentifier:title];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
            [textfield setBorderStyle:UITextBorderStyleNone];
            textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            textfield.font = [UIFont defaultTextFontWithSize:14];
            textfield.textColor = [UIColor spLightGrayColor];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.placeholder = title;
            textfield.delegate = self;
            [cell.contentView addSubview:textfield];
            
            if ([title isEqualToString:kuser]) {
                self.userTextField = textfield;
            }else if([title isEqualToString:kpwd1]){
                textfield.secureTextEntry = YES;
                self.pwdTextField = textfield;
            }else if([title isEqualToString:kpwd2]){
                textfield.secureTextEntry = YES;
                self.pwdTwoTextField = textfield;
            }else{
                self.mailTextField = textfield;
            }
        }
    }
    
    if ([title isEqualToString:kpwd3]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kpwd3];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kpwd3];
        }
        cell.backgroundColor = [UIColor spBackgroundColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-20, black2Height)];
        lable.backgroundColor = [UIColor spBackgroundColor];
        lable.text = kpwd3;
        lable.font = [UIFont defaultTextFontWithSize:textfont-2];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lable];
    }
    
    if ([title isEqualToString:kmail2]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kmail2];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kmail2];
        }
        cell.backgroundColor = [UIColor spBackgroundColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-20, black2Height)];
        lable.backgroundColor = [UIColor spBackgroundColor];
        lable.text = kmail2;
        lable.font = [UIFont defaultTextFontWithSize:textfont-2];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lable];
    }
    
    if ([title isEqualToString:kuser2]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kuser2];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kuser2];
        }
        cell.backgroundColor = [UIColor spBackgroundColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-20, black2Height)];
        lable.backgroundColor = [UIColor spBackgroundColor];
        lable.text = kuser2;
        lable.font = [UIFont defaultTextFontWithSize:textfont-2];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lable];
    }
    
   
    if ([title isEqualToString:kregister]) {
        cell = [tableView dequeueReusableCellWithIdentifier:kregister];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kregister];
        }
        cell.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-2*20, cellHeight)];
        if (self.isfind) {
             [button setTitle:@"发送邮件" forState:UIControlStateNormal];
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
        if (self.isfind) {
           lable.text = @"我们将发送密码修改的链接到您的邮箱";
        }else{
           lable.text = kconfirm;
        }
        
        lable.font = [UIFont defaultTextFontWithSize:textfont-1];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lable];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)registerButtonClicked{
    NSLog(@"注册好了");
    NSLog(@"账号:%@ 邮箱:%@ 密码 %@",self.userTextField.text,self.mailTextField.text,self.pwdTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
