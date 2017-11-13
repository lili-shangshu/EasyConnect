//
//  WarehouseController.m
//  IosBasic
//
//  Created by Star on 2017/6/21.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "WarehouseController.h"
#import "UIScrollView+RefreshControl.h"


#define cell_height 50
#define padding 10
#define textSize 15.f


@interface WarehouseController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WarehouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{mC_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell}];
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
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    
    self.title = @"请选择仓库";
}
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    self.selectResultBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

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
    
    return cell_height ;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, cell_height-10)];
    bgView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    
    
    
    
    WarehouseObject *obj = _dataArray[indexPath.row];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(padding, 5, bgView.width/2-10, bgView.height-10)];
    [lable setLabelWith:obj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize] aliment:NSTextAlignmentLeft];
    [bgView addSubview:lable];
    
    UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(lable.right, lable.top, lable.width, lable.height)];
    [phoneLable setLabelWith:[NSString stringWithFormat:@"电话：%@",obj.phone] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize] aliment:NSTextAlignmentLeft];
    [bgView addSubview:phoneLable];
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WarehouseObject *obj = _dataArray[indexPath.row];
    self.selectResultBlock(obj);
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getWarehouseWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
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
                }else
                    [self addBottomRefresh];
            });
            
        }else{
            
            if (completion) {
                completion();
            }
        }
    }];
//    WarehouseObject *object = [[WarehouseObject alloc]init];
//    object.name = @"Melbourne";
//    object.phone = @"0433433001";
//    object.id = @"123";
//    WarehouseObject *object2 = [[WarehouseObject alloc]init];
//    object2.name = @"Sydney";
//    object2.phone = @"0433433002";
//    object2.id = @"123";
//    self.dataArray = [NSMutableArray arrayWithObjects:object,object2, nil];
//    [self.tableView reloadData];
//    if (completion) {
//        completion();
//    }
    
}

- (void)refreshBottomWith:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getWarehouseWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            // Did Finish Loading
            //            [self updatePullToRefreshStringWithArray:responseObject];
            
            if (succeeded) {
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
