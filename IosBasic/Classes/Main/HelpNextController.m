//
//  HelpNextController.m
//  IosBasic
//
//  Created by li jun on 16/12/27.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "HelpNextController.h"
#import "HelpDetailController.h"
#import "NAAccesorryView.h"
#import "UIScrollView+RefreshControl.h"

#define k_responsibility  @"免责条款"
#define k_protect  @"隐私保护"
#define k_consult  @"咨询热点"
#define k_contact  @"联系我们"
#define k_company  @"公司简介"

#define text_font 15.f


@interface HelpNextController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSArray *datasArray;
@end

@implementation HelpNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView hideExtraCellHide];
    [self.tableView tableviewSetZeroInsets];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
    
    self.wifiTestTriger = YES;
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBackButton];
    self.title = self.selectObj.helpTitle;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableView Delegate
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefautCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"PostReuseID";
    ECHelpMessageObject *obj = self.datasArray[indexPath.row];
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    NAAccesorryView *accessoryView = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    accessoryView.accessoryImage = [UIImage imageNamed:@"arrowImage"];
    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell cellSetZeroInsets];
        cell.imageView.image = [UIImage imageNamed:@"helpp"];
        cell.textLabel.textColor = [UIColor spDefaultTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:text_font];
        cell.accessoryView = accessoryView;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kDefautCellHeight-1, self.view.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.2;
        [cell.contentView addSubview:lineView];
        
    }
//    cell.textLabel.text = obj.helpTitle;
    cell.textLabel.text = obj.title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInsetWithX:0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是：%@",self.datasArray[indexPath.row]);
    ECHelpMessageObject *obj = self.datasArray[indexPath.row];
    HelpDetailController *detailVC = [[HelpDetailController alloc]init];
    detailVC.selectId = obj.articleIdNum;
    [self.navigationController pushViewController:detailVC animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)refreshTopWithCompletion:(void(^)())completion
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] getHelpInfoSecondWithParams:@{@"ac_id":_selectObj.idNumber}completion:^(BOOL succeeded, id responseObject ,NSError *error){
            [SVProgressHUD dismiss];
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.datasArray = responseObject;
                    [self.tableView reloadData];
                    if (completion) {
                        completion();
                    }
                });
            }else{
                if (completion) {
                    completion();
                }
            }
        }];
    
//    self.datasArray = @[k_responsibility,k_protect,k_consult,k_contact,k_company];
//    [self.tableView reloadData];
//    if (completion) {
//        completion();
//    }
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
