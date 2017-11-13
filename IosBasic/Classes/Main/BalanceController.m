//
//  OrdersMessageController.m
//  IosBasic
//
//  Created by li jun on 16/12/15.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "BalanceController.h"
#import "UIScrollView+RefreshControl.h"
#import "SPNetworkManager.h"
#import "MMMySetSubView.h"
#import "UIView+TYAlertView.h"


#define k_product_height 120.f
#define k_textfont 18.f
#define padding 10.f

@interface BalanceController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *balaceLable;
@property(nonatomic,strong)UIView *addView;

@end

@implementation BalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setheadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.width, self.view.height  - kNavigationHeight-130)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.limits = 10;

    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{mC_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,m_SearchKey_limit:@(self.limits),m_SearchKey_page:@(self.page)}];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
//        [weakSelf showTipsWithCheckingDataArray:nil];
        [weakSelf refreshTopWithCompletion:^{
//            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
    
    self.wifiTestTriger = YES;
    
    
    // 长按删除
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = 1.5; //seconds  设置响应时间
//    lpgr.numberOfTouchesRequired = 1.0;
//    lpgr.delegate = self;
//    [self.tableView addGestureRecognizer:lpgr];
    // Do any additional setup after loading the view.
}

- (UIView *)addView{
    if (!_addView) {
        _addView = [[UIView alloc]initWithFrame:CGRectMake(NAScreenWidth/5, 180, NAScreenWidth*3/5, NAScreenHeight/3)];
        _addView.backgroundColor = [UIColor clearColor];
        _addView.hidden = YES;
        [self.view addSubview:_addView];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, _addView.width-40, _addView.height-40)];
        [button setImage:[UIImage imageNamed:@"ic_load_empty.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ic_load_empty.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(nodataBUttonCLciked) forControlEvents:UIControlEventTouchUpInside];
        [_addView addSubview:button];

    }
    return _addView;
}
- (void)nodataBUttonCLciked{
    [self refreshTableWithUpdate];
}
- (BOOL)checkingDataArray:(NSArray *)dataArray{
    if (dataArray.count==0) {
        self.addView.hidden = NO;
        return NO;
    }else{
        self.addView.hidden = YES;
        return YES;
    }
}

- (void)setheadView{
    
    UILabel *timeLalbe = [[ UILabel alloc]initWithFrame:CGRectMake(0, 20, NAScreenWidth, 20)];
    [timeLalbe setLabelWith:@"余额明细" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont-3] aliment:NSTextAlignmentCenter];
    [self.view addSubview:timeLalbe];
    
    UILabel *time2Lalbe = [[ UILabel alloc]initWithFrame:CGRectMake(0, timeLalbe.bottom, NAScreenWidth, 50)];
    [time2Lalbe setLabelWith:[NSString stringWithFormat:@"%.2f",[self.currentMember.balanceNum floatValue]] color:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:k_textfont+10] aliment:NSTextAlignmentCenter];
    self.balaceLable = time2Lalbe;
    [self.view addSubview:time2Lalbe];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(padding, time2Lalbe.bottom+5, NAScreenWidth-padding*2, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
    [button setTitle:@"充  值" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldDefaultTextFontWithSize:k_textfont];
    [button addTarget:self action:@selector(offButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)offButtonClicked{
    NSLog(@"offButtonClicked");
    MMMySetSubView *infoView = [[[NSBundle mainBundle] loadNibNamed:@"MMMySetSubView" owner:self options:nil] lastObject];
    infoView.confirmButtonBlock = ^(NSString *text) {
        self.balaceLable.text = text;
         [self refreshTableWithUpdate];
        
    };
    [infoView initWithFrame:CGRectMake((NAScreenWidth-250)/2, (NAScreenWidth-200)/2, 280, 200) WithType:1];
    [infoView showInWindow];
    
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  {
      CGPoint p = [gestureRecognizer locationInView:self.tableView ];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        弹出一个框
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];//获取响应的长按的indexpath
        if (indexPath == nil)
            NSLog(@"long press on table view but not on a row");
        else
            NSLog(@"long press on table view at row %li", indexPath.row);
        
        ECOrdersMessageObject *obj  = _dataArray[indexPath.row];
        
        UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"Delete?" message:@"删除该条消息？" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        [alertView show];
        alertView.tag = obj.idNumber.integerValue;
    }
}

// delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
            //YES应该做的事
        case 0:{
            
//            NSDictionary *paramsDict = @{m_id : self.currentMember.id,
//                                         m_member_user_shell:self.currentMember.memberShell,
//                                         m_messageid:@(alertView.tag)
//                                         };
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//            [[SPNetworkManager sharedClient] deleteOrdersMessageWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
//                if (succeeded) {
//                    [iToast showToastWithText:@"Address delete success" position:iToastGravityCenter];
//                    [self refreshTopWithCompletion:nil];
//                }
//                [SVProgressHUD dismiss];
//            }];
            NSLog(@"delete");
            break;
            
        }
            
        case 1://NO应该做的事
            break;
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [self addBackButton];
    self.title = @"余额管理";
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark----UItalbeViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_product_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"PostReuseID";

    
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell cellSetZeroInsets];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, NAScreenWidth-20, k_product_height-10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        UILabel *timeLalbe = [[ UILabel alloc]initWithFrame:CGRectMake(10, 0, (bgView.width-20)/2, 40)];
        [timeLalbe setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont] aliment:NSTextAlignmentLeft];
        cell.timeLabel = timeLalbe;
        [bgView addSubview:timeLalbe];
        
        UILabel *cashLalbe = [[ UILabel alloc]initWithFrame:CGRectMake(timeLalbe.right, 00, timeLalbe.width, 40)];
        [cashLalbe setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont] aliment:NSTextAlignmentRight];
        cell.subTitleLabel = cashLalbe;
        [bgView addSubview:cashLalbe];
        
        UILabel *contentLalbe = [[ UILabel alloc]initWithFrame:CGRectMake(10, timeLalbe.bottom, bgView.width-20, 60)];
        [contentLalbe setLabelWith:@"" color:[UIColor textFieldBorderColor] font:[UIFont defaultTextFontWithSize:k_textfont-1] aliment:NSTextAlignmentLeft];
        contentLalbe.numberOfLines = 3;
        cell.titleLabel = contentLalbe;
        [bgView addSubview:contentLalbe];
    }
    
    BalanceMessageObject *cellModel = _dataArray[indexPath.row];
    cell.timeLabel.text = cellModel.timeStr;
    cell.subTitleLabel.text = cellModel.cash;
    cell.titleLabel.text = cellModel.message;
    cell.backgroundColor = [UIColor clearColor];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    OrderDetailModel *cellModel = _dataArray[indexPath.row];

    
}
- (void)refreshTopWithCompletion:(void(^)())completion{
    
   
    
    // 接口暂未调整
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] blanceMessageWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        [SVProgressHUD dismiss];
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.dataArray = nil;
//                NSArray *filteredArray = [self filterData:responseObject withAllData:self.dataArray];
//                [self.dataArray addObjectsFromArray:filteredArray];
                
                self.dataArray = responseObject;
                [self.tableView reloadData];
                
                [self showLoadingView:NO];
                if ([self checkingDataArray:self.dataArray]) {
                    
                }
                
                if (completion) {
                    completion();
                }
                NSMutableArray *array  = responseObject;
                if ([array count] < self.limits) {
                    [self.tableView removeBottomRefreshControl];
                }else{
                    [self addBottomRefresh];
                }
            });
            
        }else{
            if (completion) {
                completion();
            }
        }
    }];
}
- (void)refreshBottomWith:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] blanceMessageWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {
//                NSArray *filteredArray = [self filterData:responseObject withAllData:self.dataArray];
                [self.dataArray addObjectsFromArray:responseObject];
                [self.tableView reloadData];
            }
            if (completion) {
                completion();
            }
            NSMutableArray *array  = responseObject;
            if ([array count] < self.limits) {
                [self.tableView removeBottomRefreshControl];
            }else
                [self addBottomRefresh];
        });
    }];
}

- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
}

- (void)reloadingDataAction:(id)sender
{
    [self refreshTableWithUpdate];
    
}

- (void)refreshTableWithUpdate
{
    [self showLoadingView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTopWithCompletion:^{
//            [self showTipsWithCheckingDataArray:self.dataArray];
        }];
    });
}
- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addBottomRefreshControlUsingBlock:^{
        [weakSelf refreshBottomWith:^{
            [weakSelf.tableView bottomRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
}
- (NSArray *)filterData:(NSArray *)data withAllData:(NSArray *)allData
{
    NSMutableArray *filteredData = [NSMutableArray array];
    for(ECOrdersMessageObject *object in data) {
        
        BOOL objectCanBeAdded = YES;
        
        for (ECOrdersMessageObject *object2 in allData)
        {
            if (object.idNumber.integerValue == object2.idNumber.integerValue) {
                objectCanBeAdded = NO;
            }
        }
        
        if (objectCanBeAdded) {
            [filteredData addObject:object];
        }
    }
    return filteredData;
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
