//
//  OrdersController.m
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "OrdersController.h"
#import "UIScrollView+RefreshControl.h"
#import "OrdersCellView.h"

#import "OrderDetailController.h"
#import "CommmentController.h"
#import "CartConfirmSecondController.h"
#import "PickerChoiceView.h"

@interface OrdersController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate,CommmentControllerDelegate>

@end

@implementation OrdersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight-kTabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
//    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"member_id":self.currentMember.id,
//                                                                            m_member_user_shell:self.currentMember.memberShell,
//                                                                            m_SearchKey_limit:@(self.limits),
//                                                                            m_SearchKey_page:@(self.page)}];
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{mC_id:self.currentMember.id,
                                                                            m_member_user_shell:self.currentMember.memberShell,
                                                                            m_SearchKey_limit:@(self.limits),
                                                                            m_SearchKey_page:@(self.page)}];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf showTipsWithCheckingDataArray:nil];
        
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
    
    self.wifiTestTriger = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:kSPPay object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)payResult:(NSNotification *)notification{

    [self reloadingDataAction:nil];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
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
    ECOrdersObject *cellModel = _dataArray[indexPath.row];
    return [OrdersCellView ViewHeightWithProduct:cellModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"PostReuseID";
    ECOrdersObject *cellModel = _dataArray[indexPath.row];
    
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        OrdersCellView *orderView = [[OrdersCellView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, 44.f)];
        cell.customView1 = orderView;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:orderView];
    }
    
    OrdersCellView *orderView = (OrdersCellView *)cell.customView1;
    [orderView updateViewWithOrder:cellModel];
    // 支付的
    orderView.payButtonBlock = ^(ECOrdersObject *model){
//         [SVProgressHUD showInfoWithStatus:@"暂不支持线上付款"];
        CartConfirmSecondController *secondC = [[CartConfirmSecondController alloc]init];
        // 可能产生几个订单的情况
        secondC.isOrderpay = YES;
        secondC.ordersArray = @[model];
        [self.navigationController pushViewController:secondC animated:YES];
    };
    
    // 取消订单
    orderView.cancleButtonBlock = ^(ECOrdersObject *model){
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        picker.selectLb.text = @"";
        picker.orderId = model.idNumber;
        picker.customArr = @[@"改选其他商品",@"改选其他配送方式",@"不想买了",@"其他原因"];
        picker.delegate =self;
        [self.view addSubview:picker];
    };

    // 确认收货
    orderView.confirmButtonBlock = ^(ECOrdersObject *model){
        NSDictionary *dic = @{mC_id:self.currentMember.id,
                              m_member_user_shell:self.currentMember.memberShell,
                              m_statetype:@"order_receive",
                              m_orderid:model.idNumber
                              };
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] cancleAndConfirmOrderWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (succeeded) {
                NSLog(@"确认收货");
                [SVProgressHUD showInfoWithStatus:@"操作成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kSPPay object:nil userInfo: nil];
            }
        }];
        
    };
    
    // 删除订单
    orderView.deleteButtonBlock = ^(ECOrdersObject *model){
        NSDictionary *dic = @{mC_id:self.currentMember.id,
                              m_member_user_shell:self.currentMember.memberShell,
                              m_statetype:@"order_delete",
                              m_orderid:model.idNumber
                              };
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] cancleAndConfirmOrderWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
           
            if (succeeded) {
                [SVProgressHUD showInfoWithStatus:@"删除订单成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kSPPay object:nil userInfo: nil];
            }
        }];
    };
    
    // 评论的
    orderView.commentButtonBlock = ^(ECOrdersObject *model){
        // 暂无评论功能
        //        CommmentController *commentVC = [[CommmentController alloc]init];
        //        commentVC.OrdersObj = cellModel;
        //        commentVC.delegate = self;
        //        [self.navigationController pushViewController:commentVC animated:YES
        //         ];
    };
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ECOrdersObject *obj = _dataArray[indexPath.row];
//    
//    OrderDetailController *obj2 = [[OrderDetailController alloc]init];
//    obj2.orderId = obj.idNumber;
//    obj2.selectObj = obj;
//    [self.navigationController pushViewController:obj2 animated:YES];
}
#pragma mark -------- CommmentController  Delegate
//- (void)updateOrdersList:(NSString *)orderId{
//    for (ECOrdersObject *obj in self.dataArray) {
//        if ([obj.idNumber isEqualToString:orderId]) {
//            [self.dataArray removeObject:obj];
//        }
//    }
//    [self refreshTopWithCompletion:nil];
//}
#pragma mark -------- TFPickerDelegate
// 取消订单
- (void)PickerSelectorIndixString:(NSString *)str WithOrderId:(NSString *)idNumber{
//    NSDictionary *dic = @{mC_id:self.currentMember.id,
//                          m_member_user_shell:self.currentMember.memberShell,
//                          m_statetype:@"order_cancel",
//                          m_orderid:idNumber,
//                          @"state_info":str};
    if (str) {
        NSDictionary *dic = @{mC_id:self.currentMember.id,
                              m_member_user_shell:self.currentMember.memberShell,
                              m_statetype:@"order_cancel",
                              m_orderid:idNumber};
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] cancleAndConfirmOrderWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                NSLog(@"取消订单");
                [SVProgressHUD showInfoWithStatus:@"取消订单成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSPPay object:nil userInfo: nil];
            }
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
  [self refreshTopWithCompletion:^{
      [self showTipsWithCheckingDataArray:self.dataArray];
  }];
}

- (void)refreshTopWithCompletion:(void(^)())completion
{
    NSString *stateType = @"";
//    1-5
    switch (_typeIndex) {
        case 2:
            stateType = @"state_new";
            break;
        case 3:
            stateType = @"state_pay";
            break;
        case 4:
            stateType = @"state_send";
            break;
        case 5:
            stateType = @"state_complete";
            break;
        default:
            stateType = @"";
            break;
    }
    
    [self.filterDictionary setObject:stateType forKey:@"state_type"];
    [[SPNetworkManager sharedClient] getUserOrderWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = responseObject;
                [self.tableView reloadData];
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
    [[SPNetworkManager sharedClient] getUserOrderWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.dataArray = nil;
//                NSArray *filteredArray = [self filterData:responseObject withAllData:self.dataArray];
//                [self.dataArray addObjectsFromArray:filteredArray];
                
                 [self.dataArray addObjectsFromArray:responseObject];
                
                [self.tableView reloadData];
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
    for(ECOrdersObject *object in data) {
        
        BOOL objectCanBeAdded = YES;
        
        for (ECOrdersObject *object2 in allData)
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
- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
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
