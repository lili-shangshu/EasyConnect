//
//  SetViewController.m
//  IosBasic
//
//  Created by Star on 2017/11/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLable;
@property (weak, nonatomic) IBOutlet UILabel *idLable;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *versionLable;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.welcomeLable.text = [NSString stringWithFormat:@"Welcome back %@",self.currentMember.name];
    self.idLable.text = [NSString stringWithFormat:@"ID: %@",self.currentMember.work_num];
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLable.text = versionString;
 
    if ([self.currentMember.isAccept integerValue] == 1) {
        self.notificationSwitch.on = YES;
    }else{
        self.notificationSwitch.on = NO;
    }
    [self addBackButton];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)notificationSwitched:(UISwitch *)sender {
    NSNumber *typeNum = @(1);
    if (sender.on) {
        NSLog(@"接受通知");
        typeNum = @(1);
    }else{
        NSLog(@"拒绝通知");
        typeNum = @(0);
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] postChangeNotificationWithParams:@{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"is_notify":typeNum} completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            self.currentMember.isAccept = typeNum;
            MR_SaveToPersitent_For_CurrentThread;
        }
    }];
    
}

- (IBAction)logoutButtonClicked:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (self.loginoutButtonClicked) {
        self.loginoutButtonClicked(YES);
    }
}
- (void)viewWillAppear:(BOOL)animated{
    self.title = @"SETTINGS";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
