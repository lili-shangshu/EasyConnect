//
//  SPSpriteCardController.m
//  IosBasic
//
//  Created by Star on 2017/9/29.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "SPSpriteCardController.h"

#import "SPAddCardController.h"
#import "UIScrollView+RefreshControl.h"
#import "SPNetworkManager.h"
#import "AppDelegate.h"



#define cell_height 65.f
#define herizon_padding 20.f
#define vertical_padding 15.f


@interface SPSpriteCardController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation SPSpriteCardController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50 - kNavigationHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding, self.tableView.bottom, self.view.width-herizon_padding*2, 40)];
    [addButton setTitle:@"添加卡支付" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor spThemeColor];
    addButton.layer.cornerRadius = addButton.height/2;
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":self.currentMember.id}];
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithUpdate) name:kSPStripeCardUpdate object:nil];
    
    //[SPMember updateMemberInfo];
    
    [self addBackButton];
}

- (void)addButtonAction:(id)sender{
    
    SPAddCardController*addCardViewController = [[SPAddCardController alloc]init];
    [self.navigationController pushViewController:addCardViewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cell_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPStriptCardObject *object = _dataArray[indexPath.row];
    
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card"];
    //    if (cell == nil) {
    cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"card"];
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(herizon_padding, herizon_padding/2, 80, 45)];
    [typeLabel setLabelWith:object.brand color:[UIColor blueIOSColor] font:[UIFont boldSystemFontOfSize:16] aliment:NSTextAlignmentCenter];
    [typeLabel sizeToFit];
    typeLabel.height = 45;
    [cell.contentView addSubview:typeLabel];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.right+herizon_padding/4, herizon_padding/2, 80, 45)];
    [endLabel setLabelWith:@"尾号为" color:[UIColor grayColor] font:[UIFont systemFontOfSize:15] aliment:NSTextAlignmentCenter];
    [endLabel sizeToFit];
    endLabel.height = 45;
    [cell.contentView addSubview:endLabel];
   
    UILabel *last4Label = [[UILabel alloc] initWithFrame:CGRectMake(endLabel.right+herizon_padding/4, herizon_padding/2, 80, 45)];
    [last4Label setLabelWith:object.last4 color:[UIColor blackColor] font:[UIFont systemFontOfSize:16] aliment:NSTextAlignmentCenter];
    [last4Label sizeToFit];
    last4Label.height = 45;
    [cell.contentView addSubview:last4Label];
    
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.textColor = [UIColor grayColor];
    deleteLabel.text = @"删除";
    deleteLabel.top = 25;
    deleteLabel.height = 20;
    deleteLabel.font = [UIFont systemFontOfSize:13];
    [deleteLabel sizeToFit];
    deleteLabel.right = NAScreenWidth-herizon_padding;
    [cell.contentView addSubview:deleteLabel];
    
    
    UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(herizon_padding*1.5, deleteLabel.top+2, 15, 15)];
    deleteView.right = deleteLabel.left-5;
    deleteView.image = [UIImage imageNamed:@"icon_delete"];
    [cell.contentView addSubview:deleteView];
    
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(deleteView.left,deleteView.top,deleteLabel.right-deleteView.left,deleteLabel.height)];
    deleteButton.tag = indexPath.row;
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButton];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height-1, self.view.width, 1)];
    bottomView.backgroundColor = [UIColor grayColor];
    bottomView.alpha = 0.3;
    [cell.contentView addSubview:bottomView];
    
    if (!_orderId) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}




- (void)deleteButtonAction:(UIButton *)button{
    
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"删除卡" message:@"是否删除" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"取消",nil];
    [alertView show];
    alertView.tag = button.tag;
    
    
}
// delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
            //YES应该做的事
        case 0:{
            NSInteger index = alertView.tag;
            SPStriptCardObject *object = _dataArray[index];
            NSDictionary *paramsDict = @{@"userId" : self.currentMember.id,
                                         @"cardId" : object.id,
                                         m_member_user_shell:[NADefaults sharedDefaults].memberUserShell
                                         };
            
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//            [[SPNetworkManager sharedClient] postDeleteStripeCardWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
//                if (succeeded) {
//
//                    [SVProgressHUD showSuccessWithStatus:CustomLocalizedString(@"card_delete_succ", nil)];
//                    [self refreshTableWithUpdate];
//                }
//
//            }];
            
            [SVProgressHUD showSuccessWithStatus:@"删除卡"];
            NSLog(@"delete%@",paramsDict);
            
            break;
            
        }
            
        case 1://NO应该做的事
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_orderId) {
//        SPStriptCardObject *object = _dataArray[indexPath.row];
//        NSDictionary *paramsDict = @{@"userId" : self.currentMember.id,
//                                     @"orderId" : self.orderId,
//                                     @"isUserMoney" : self.isUseMoney,
//                                     @"cardId" : object.id,
//                                     m_member_user_shell:[NADefaults sharedDefaults].memberUserShell
//                                     };
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//        [[SPNetworkManager sharedClient] postStripeSaleWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
//            if (succeeded) {
//
//                [SVProgressHUD dismiss];
//
//                NAPostNotification(kSPOrderUpdate, nil);
//                NAPostNotification(kSPTabbarChange, nil);
//                [SPMember updateMemberInfo];
//                NAPostNotification(kSPLoginStatusChanged, nil);
//                [self showSuccess];
//            }else{
//                [SVProgressHUD dismiss];
//                // [iToast showToastWithText:@"Pay failed" position:iToastGravityCenter witduration:2000];
//            }
//        }];
//    }
    
}

- (void)showSuccess{

    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    //    [navController applyAppDefaultApprence];
    //    [self presentViewController:navController animated:YES completion:^{
    //
    //    }];
    
}

#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////


- (void)reloadingDataAction:(id)sender
{
    [self refreshTableWithUpdate];
    
}

- (void)refreshTableWithUpdate
{
    [self showLoadingView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTopWithCompletion:^{
            [self showTipsWithCheckingDataArray:self.dataArray];
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
    } ];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)refreshTopWithCompletion:(void(^)())completion
{
    NSMutableArray *testArray = [NSMutableArray array];
    SPStriptCardObject *obj1 = [[SPStriptCardObject alloc]init];
    obj1.brand = @"银联";
    obj1.last4 = @"1111";
    [testArray addObject:obj1];
    
    SPStriptCardObject *obj2 = [[SPStriptCardObject alloc]init];
    obj2.brand = @"支付宝";
    obj2.last4 = @"2222";
    [testArray addObject:obj2];
    
    SPStriptCardObject *obj3 = [[SPStriptCardObject alloc]init];
    obj3.brand = @"微信";
    obj3.last4 = @"3333";
    [testArray addObject:obj3];
    self.dataArray = testArray;
    [self.tableView reloadData];
    if (completion) {
        completion();
    }

    
    
//    [self.filterDictionary setObject:[NADefaults sharedDefaults].memberUserShell forKey:m_member_user_shell];
//    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
//    [[SPNetworkManager sharedClient] getSpriteCardWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
//        if (succeeded) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.dataArray = responseObject;
//                [self.tableView reloadData];
//                if (completion) {
//                    completion();
//                }
//                NSMutableArray *array  = responseObject;
//                if ([array count] < self.limits) {
//                    [self.tableView removeBottomRefreshControl];
//                }else
//                    [self addBottomRefresh];
//            });
//
//        }else{
//
//            if (completion) {
//                completion();
//            }
//        }
//    }];
    
    
    
    
}

- (void)refreshBottomWith:(void(^)())completion
{
//    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
//    [[SPNetworkManager sharedClient] getSpriteCardWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Did Finish Loading
//            //            [self updatePullToRefreshStringWithArray:responseObject];
//
//            if (succeeded) {
//                [self.dataArray addObjectsFromArray:responseObject];
//                [self.tableView reloadData];
//
//            }
//            if (completion) {
//                completion();
//            }
//            NSMutableArray *array  = responseObject;
//            if ([array count] < self.limits) {
//                [self.tableView removeBottomRefreshControl];
//            }else
//                [self addBottomRefresh];
//        });
//    }];
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
