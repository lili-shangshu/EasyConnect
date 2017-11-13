//
//  MySetController.m
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "MySetController.h"
#import "NAAccesorryView.h"
#import "NAWebController.h"
#import "AboutUSViewController.h"

#define k_image  @"展示高清图片"
#define k_message  @"消息接收通知"
#define k_clear  @"清除缓存"
#define k_Telephone  @"客服电话"
#define k_aboutUS  @"关于我们"
#define k_loginOut  @"退出登录"

@interface MySetController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSArray *titles;
@property(strong,nonatomic)UISwitch *imageSwitch;
@property(strong,nonatomic)UISwitch *messageSwitch;

@end

@implementation MySetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor gray5];
    
    if (self.currentMember) {
        self.titles = @[k_image,k_message,k_clear,k_Telephone,k_aboutUS,k_loginOut];
    }else{
        self.titles = @[k_image,k_message,k_clear,k_Telephone,k_aboutUS];
    }
    
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.height = self.view.height - kTransulatInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView hideExtraCellHide];
    [self.tableView tableviewSetZeroInsets];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self addBackButton];
    self.title = @"设置";
    self.navigationController.navigationBarHidden = NO;
    
    self.imageBool = YES;
    self.messageBool = YES;
}
#pragma mark - TableView Delegate & DataSource
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.titles objectAtIndex:indexPath.row];
    if ([title isEqualToString:k_loginOut]) {
        return 3.5*kDefautCellHeight;
    }
    return kDefautCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"No need To Reuse"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NAAccesorryView *accessoryView = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 200, kDefautCellHeight)];
    accessoryView.accessoryImage = [UIImage imageNamed:@"arrowImage"];
    cell.accessoryView = accessoryView;
    
    NSString *title = [self.titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor spDefaultTextColor];
    cell.textLabel.text = title;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kDefautCellHeight-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.2;
    [cell.contentView addSubview:lineView];
    
    
    if ([title isEqualToString:k_image])
    {
        UISwitch *swith = [[UISwitch alloc]init];
        if (self.imageBool) {
            [swith setOn:YES animated:YES];
        }else{
             [swith setOn:YES animated:YES];
        }
        
        
        [swith addTarget:self action:@selector(imagesSwitchClick:) forControlEvents:UIControlEventValueChanged];
        self.imageSwitch= swith;
        cell.accessoryView = swith;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([title isEqualToString:k_message]) {
        UISwitch *swith = [[UISwitch alloc]init];
        if (self.imageBool) {
            [swith setOn:YES animated:YES];
        }else{
            [swith setOn:YES animated:YES];
        }
        [swith addTarget:self action:@selector(messageSwitchClick:) forControlEvents:UIControlEventValueChanged];
        self.messageSwitch= swith;
        cell.accessoryView = swith;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([title isEqualToString:k_clear]) {
        accessoryView.textLabel.text = @"12.3 M";
    }
    
    if ([title isEqualToString:k_Telephone]) {
        
    }
    
    if ([title isEqualToString:k_aboutUS]) {
       
    }
    
    if ([title isEqualToString:k_loginOut]) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20.f, 2.5*kDefautCellHeight, self.view.width-40.f, 0.8*kDefautCellHeight)];
        [button setBackgroundColor:[UIColor black1]];
        button.layer.cornerRadius = 5.f;
        button.layer.masksToBounds = YES;
        [button setTitle:k_loginOut forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginOutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:button];
        cell.accessoryView = nil;
        cell.textLabel.text = @"";
        [lineView removeFromSuperview];
    }
    
    [cell setInsetWithX:15.f];
   
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titles[indexPath.row];
    if ([title isEqualToString:k_clear]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定清除缓存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         UIAlertAction *OKlAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             NSLog(@"清除内存");
         }];
        [alertC addAction:cancelAction];
        [alertC addAction:OKlAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    if ([title isEqualToString:k_Telephone]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"拨打电话" message:@"65615500" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *OKlAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拨打电话65615500");
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:OKlAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    
    
    if ([title isEqualToString:k_aboutUS]) {
        
//        NSString *urlStr = @"http://www.baidu.com";
//        NAWebController *controller = [[NAWebController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
//        
//        [(NAWebController *)controller setUrlString:urlStr];
//        [(NAWebController *)controller setHideShareButton:YES];
//        

        AboutUSViewController *aboutUSVC = [[AboutUSViewController alloc]init];
        
        
        [self.navigationController pushViewController:aboutUSVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-- swtich
- (void)imagesSwitchClick:(UISwitch *)swithc{
    if (swithc.on) {
        NSLog(@"显示高清");
    }else{
        NSLog(@"不显示高清");
    }
}
- (void)messageSwitchClick:(UISwitch *)swithc{
    if (swithc.on) {
        NSLog(@"接受消息");
    }else{
        NSLog(@"不接受消息");
    }
}
- (void)loginOutButtonClick{
    NSLog(@"退出登录");
    [NADefaults sharedDefaults].username = nil;
    [NADefaults sharedDefaults].currentMemberId  = nil;
    NAPostNotification(kSPLoginStatusChanged, nil);  // 更新我的页面
    NAPostNotification(kSPShopCartChange, nil);     // 更新角标
    
    self.leaveBlock(@"out");
   [self.navigationController popViewControllerAnimated:YES];
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
