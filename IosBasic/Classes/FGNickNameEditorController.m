//
//  FGNickNameEditorController.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/31.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "FGNickNameEditorController.h"
#import "SPNetworkManager.h"


@interface FGNickNameEditorController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *editorTextField;

@end

@implementation FGNickNameEditorController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.isEmail){
        self.title = @"昵称";
    }else{
        self.title = @"邮箱";
    }
    
    self.view.backgroundColor = [UIColor spBackgroundColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"取消" titleColor:[UIColor spDefaultTextColor] target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"保存" titleColor:[UIColor spDefaultTextColor] target:self action:@selector(saveButtonAction:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView hideExtraCellHide];
    self.tableView.height = self.view.height - kTransulatInset;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.inNavController = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.editorTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.editorTextField isFirstResponder]) {
        [self tryBecomingFirstResbonder];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tryBecomingFirstResbonder
{
    [self.editorTextField becomeFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Actions
////////////////////////////////////////////////////////////////////////////////////

- (void)cancelButtonAction:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonAction:(id)sender
{
    [self.editorTextField resignFirstResponder];
    if ([self.editorTextField.text isEmptyString]) {
        [iToast showToastWithText:@"不可以为空" position:iToastGravityBottom];
        return;
    }
    
    
    if (self.isEmail) {
        if (![self.editorTextField.text isEqualToString:self.currentMember.email]) {
            if (self.doneWithString) {
                self.doneWithString(self.editorTextField.text);
            }
            NSDictionary *dic = @{m_id:self.currentMember.id,
                                  m_member_user_shell:self.currentMember.memberShell,
                                  @"email":self.editorTextField.text,
                                  m_editType:@"email"};
            [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
                if (succeeded) {
                    self.currentMember.email = self.editorTextField.text;
                    MR_SaveToPersitent_For_CurrentThread;
    //                NAPostNotification(kSPUpdateMemberInfo, nil);
                }
            }];
        }
    }else{
        if (![self.editorTextField.text isEqualToString:self.currentMember.nickName]) {
            if (self.doneWithString) {
                self.doneWithString(self.editorTextField.text);
            }
            NSDictionary *dic = @{m_id:self.currentMember.id,
                                  m_member_user_shell:self.currentMember.memberShell,
                                  @"newname":self.editorTextField.text,
                                  m_editType:@"newname"};
            
            [[SPNetworkManager sharedClient] changUserInfoWithParams:dic completion:^(BOOL succeeded, id responseObject ,NSError *error){
                if (succeeded) {
                    self.currentMember.nickName = self.editorTextField.text;
                    MR_SaveToPersitent_For_CurrentThread;
    //                NAPostNotification(kSPUpdateMemberInfo, nil);
                }
            }];
        }
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate & DataSource
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return kSectionHeight;
    return kDefautCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No Reuse"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor spBackgroundColor];
    }else{
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.f, 7.f, self.view.width-15.f*2, 30.f)];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor grayColor];
        self.editorTextField = textField;
        NSString *stri = @"";
        if (self.isEmail) {
             stri = (self.currentMember.email && [self.currentMember.email isKindOfClass:[NSString class]] && ![self.currentMember.email isEqualToString:@""])? self.currentMember.email : kDefaultUsername;
        }else{
            stri = (self.currentMember.nickName && [self.currentMember.nickName isKindOfClass:[NSString class]] && ![self.currentMember.nickName isEqualToString:@""])? self.currentMember.nickName : kDefaultUsername;

        }
        self.editorTextField.text =
        self.editorTextField.placeholder = @"输入昵称";
        [self performSelector:@selector(tryBecomingFirstResbonder) withObject:nil afterDelay:0.2f];
        [cell.contentView addSubview:textField];
    }
    
    return cell;
    
}

@end
