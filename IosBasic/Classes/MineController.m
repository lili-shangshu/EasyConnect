//
//  MineController.m
//  IosBasic
//
//  Created by li jun on 16/10/9.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "MineController.h"
#import "NAAccesorryView.h"
#import "MySetController.h"
#import "UserInfoController.h"
#import "OrdersManagerController.h"
#import "CollectViewController.h"
#import "AdressViewController.h"
#import "AddressManagerViewController.h"
#import "HelpCentreController.h"
#import "LoginViewController.h"
#import "MemberController.h"
#import "SPModifyPwController.h"
#import "AboutUSViewController.h"
#import "AgentApplyController.h"
#import "AgentController.h"
#import "BalanceController.h"

#define pic_height 140.f
#define avatar_width 95.f
#define title_height 50.f


#define blank_height 15.f
#define padding 10.f
#define herizon_padding 20.f
#define text_font 15.f


@interface MineController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSArray *titleData;
@property(strong,nonatomic)UILabel *userNameLable;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor spThemeColor];
    
//    self.titleData = @[@"pic",@"Myorder",@"favorite",@"blance",@"address",@"info",@"promoter",@"psd",@"helps",@"off"];
    
//     self.titleData = @[@"pic",@"Myorder",@"favorite",@"blance",@"address",@"info",@"psd",@"off"];

    self.titleData = @[@"pic",@"Myorder",@"favorite",@"address",@"info",@"psd",@"off"];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-48-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMemberInfo) name:kSPLoginStatusChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationController.navigationBarHidden = NO;
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.title=@"我的帐号";
 
//    暂不加入
//    [self shouldPresentLoginControllerWithCompletion:^(BOOL succeed){
//        if (succeed) {
//            //更新余额
//            [SPMember updateMemberInfo];
//        }
//    }];
    if (self.currentMember) {
        [SPMember updateMemberInfo];
    }

    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification Handler
////////////////////////////////////////////////////////////////////////////////////

- (void)updateMemberInfo
{
    [self shouldPresentLoginControllerWithCompletion:^(BOOL succeed){
        if (succeed) {
            [self.tableView reloadData];
        }
    }];

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
    return self.titleData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.titleData[indexPath.row];
    if ([title isEqualToString:@"pic"]) {
        return pic_height;
    }else if ([title isEqualToString:@"off"]) {
        return 2*kDefautCellHeight;
    }else{
        return kDefautCellHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell;
    NSString *title = self.titleData[indexPath.row];
    NAAccesorryView *accessoryView = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    accessoryView.accessoryImage = [UIImage imageNamed:@"arrowImage"];
    
    
    if ([title isEqualToString:@"pic"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"pic"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pic"];
        }
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-herizon_padding, pic_height-herizon_padding)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
     
        UIImageView *avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(herizon_padding, 15, bgView.height-30, bgView.height-30)];
        //头像
        avatarImgView.image = [UIImage imageNamed:@"avatar"];
        if (![self.currentMember.avatar isEqualToString:@"http://warehouse.legenddigital.com.au/data/upload/data/upload/no-avatar.png"]) {
             [avatarImgView setImageWithFadingAnimationWithURL:[NSURL URLWithString:self.currentMember.avatar]];
        }
        avatarImgView.layer.cornerRadius = avatarImgView.width/2;
        avatarImgView.layer.masksToBounds = YES;
        [bgView addSubview:avatarImgView];
        
//        UIButton *avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding*1.8, herizon_padding*3.6, avatar_width, avatar_width)];
//        avatarButton.layer.cornerRadius = avatarButton.width/2;
//        [avatarButton addTarget:self action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:avatarButton];
        
//        用户名
        UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(avatarImgView.right +padding, 10, bgView.width-avatarImgView.right-2*padding, 30)];
        if (self.currentMember) {
             userNameLabel.text = self.currentMember.nickName;
        }
        userNameLabel.textColor = [UIColor spThemeColor];
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        userNameLabel.font = [UIFont boldDefaultTextFontWithSize: text_font+4];
        self.userNameLable = userNameLabel;
        [bgView addSubview:userNameLabel];
        
        // 什么高级会员
        UILabel *viplable = [[UILabel alloc]initWithFrame:CGRectMake(userNameLabel.left, userNameLabel.bottom, userNameLabel.width, 15)];
        NSString *str = [NSString stringWithFormat:@"高级会员"];
        if (self.currentMember.levelStr) {
            str = self.currentMember.levelStr;
        }
        [viplable setLabelWith:str color:[UIColor redColor] font:[UIFont defaultTextFontWithSize:text_font-4] aliment:NSTextAlignmentLeft];
        [bgView addSubview:viplable];
        
        // 积分
        UILabel *pointlable = [[UILabel alloc]initWithFrame:CGRectMake(viplable.left, viplable.bottom+15, viplable.width, 20)];
        str = [NSString stringWithFormat:@"累计消费：%d",[self.currentMember.totalCost intValue]];
        [pointlable setLabelWith:str color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-3] aliment:NSTextAlignmentLeft];
        [bgView addSubview:pointlable];
        
        // 累计消费
        UILabel *payLable = [[UILabel alloc]initWithFrame:CGRectMake(pointlable.left, pointlable.bottom, pointlable.width, 20)];
        str = [NSString stringWithFormat:@"余额：%d",[self.currentMember.balanceNum intValue]];
        [payLable setLabelWith:str color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-3] aliment:NSTextAlignmentLeft];
        [bgView addSubview:payLable];
        
    }else if([title isEqualToString:@"Myorder"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Myorder"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Myorder"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"我的订单" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 15, 8, 15)];
        imageView.image = [UIImage imageNamed:@"arrowImage"];
        [bgview addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
        
    }else if([title isEqualToString:@"favorite"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"favorite"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favorite"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"我的收藏" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 15, 8, 15)];
        imageView.image = [UIImage imageNamed:@"arrowImage"];
        [bgview addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
        
    }else if([title isEqualToString:@"blance"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"blance"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blance"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"余额管理" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 15, 8, 15)];
        imageView.image = [UIImage imageNamed:@"arrowImage"];
        [bgview addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
        
    }else if([title isEqualToString:@"address"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"address"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"地址管理" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 15, 8, 15)];
        imageView.image = [UIImage imageNamed:@"arrowImage"];
        [bgview addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
        
    }else if([title isEqualToString:@"info"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"个人信息" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.right, 15, 8, 15)];
        imageView.image = [UIImage imageNamed:@"arrowImage"];
        [bgview addSubview:imageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
        
    }else if([title isEqualToString:@"psd"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"psd"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"psd"];
        }
        // 50
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, kDefautCellHeight)];
        bgview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgview.width-3*padding, kDefautCellHeight-10)];
        [label setLabelWith:@"修改密码" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentLeft];
        [bgview addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgview.height-1, bgview.width,1)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [bgview addSubview:lineView];
    }else if([title isEqualToString:@"off"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"off"];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"off"];
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-herizon_padding, kDefautCellHeight)];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
        [button setTitle:@"注  销" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldDefaultTextFontWithSize:text_font+2];
        [button addTarget:self action:@selector(offButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     __weak typeof(self) weakSelf = self;
    [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
        NSString *title = self.titleData[indexPath.row];
        UIViewController *controller;

        if ([title isEqualToString:@"Myorder"]) {
            controller = [[OrdersManagerController alloc]init];
        }
        if ([title isEqualToString:@"favorite"]) {
            controller = [[CollectViewController alloc]init];
            controller.title  = @"我的收藏";
        }
        if([title isEqualToString:@"blance"]){
            controller = [[BalanceController alloc] init];
            controller.title = @"余额管理";
        }
        if ([title isEqualToString:@"address"]) {
            controller = [[AddressManagerViewController alloc]init];
            controller.title = @"地址管理";
        }
       if ([title isEqualToString:@"pic"]||[title isEqualToString:@"info"]) {
            controller = [[UserInfoController alloc]init];
        }
        
        
        
      if ([title isEqualToString:@"psd"]) {
           controller = [[SPModifyPwController alloc]init];
          

      }
      
        
        
        if (controller) {
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    
    
    
}

#pragma mark---button
- (void)offButtonClicked{
    
    NSLog(@"退出登录");

    [NADefaults sharedDefaults].currentMemberId  = nil;
    [NADefaults sharedDefaults].password = nil;
    NAPostNotification(kSPLoginStatusChanged, nil);
    NAPostNotification(kSPShopCartChange, nil);     // 更新角标
    [self shouldPresentLoginControllerWithCompletion:^(BOOL succeed){
        if (succeed) {
            [self.tableView reloadData];
        }else
        {
            self.tabBarController.selectedIndex = 0;
        }
    }];

}
- (void)avatarButtonAction:(UIButton *)button{
    NSLog(@"点击头像");
    UserInfoController *userVC = [[UserInfoController alloc]init];
    [self.navigationController pushViewController:userVC animated:YES];
   
}
- (void)orderBtnAction:(UIButton *)button{
    NSLog(@"点击订单----%ld",button.tag);
    OrdersManagerController *ordersVC = [[OrdersManagerController alloc]init];
    ordersVC.selectNum = [NSNumber numberWithInteger:button.tag];
    [self.navigationController pushViewController:ordersVC animated:YES];
    
}
- (void)settingButtonAction:(UIButton *)button{
//    NSLog(@"点击设置");
    MySetController *mysetVC = [[MySetController alloc]init];
    [self.navigationController pushViewController:mysetVC animated:YES];
    
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
