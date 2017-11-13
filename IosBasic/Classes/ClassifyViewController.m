//
//  ClassifyViewController.m
//  IosBasic
//
//  Created by li jun on 17/4/15.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "ClassifyViewController.h"
#import "UIScrollView+RefreshControl.h"
#import "ClassifyCellView.h"
//#import "ClassifyCellView2.h"
#import "ClassifyGoodsController.h"

#define padding 10
#define textSize 15




@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,ClassifyCellViewDelegate>


@property (nonatomic, strong) NSMutableArray *categoryData;
@property (nonatomic, strong) NSMutableArray *productData;

@end

@implementation ClassifyViewController


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    self.tabBarController.navigationItem.leftBarButtonItems = nil;
    self.tabBarController.title=@"分 类";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  [self initData]
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight-kTabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf showTipsWithCheckingDataArray:nil];
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf showTipsWithCheckingDataArray:weakSelf.categoryData];
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
//    self.wifiTestTriger = YES;
    
}
- (void)initData{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] getClassifyOfGoodsWithCompletion:^(BOOL succeeded, id responseObject, NSError *error) {
        if(succeeded &&responseObject){
            [SVProgressHUD dismiss];
            NSArray *allData = responseObject;
            NSMutableArray *leftArray = [NSMutableArray array];
            NSMutableArray *rightArray = [NSMutableArray array];
            for (ECClassifyGoodsObject * obj in allData) {
                [leftArray addObject:obj];
                [rightArray addObject:obj.classifysArray];
            }
            self.categoryData = leftArray;
            self.productData = rightArray;
        }else{
            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"加载失败" message:nil delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
//- (void)reloadingDataAction:(id)sender{
//    [self refreshTopWithCompletion:^{
//        [self showTipsWithCheckingDataArray:self.categoryData];
//        [self.tableView topRefreshControlStopRefreshing];
//    }];
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ClassifyCellView ViewHeightproductArray:self.productData[indexPath.row]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cuisine"];
    if (cell == nil) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cuisine"];
        ClassifyCellView *view = [[ClassifyCellView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, 50)];
        cell.customView1 = view;
        [cell.contentView addSubview:view];
    }
    ClassifyCellView *view = (ClassifyCellView *)cell.customView1;
    view.delegate = self;
    ECClassifyGoodsObject *obj = self.categoryData[indexPath.row];
    NSArray *dataArray = self.productData[indexPath.row];
    [view UpdateViewWithProduct:obj withproductArray:dataArray];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - ClassifyCellView---Delegate
- (void)clickedCategoods:(ECClassifyGoodsObject *)goodsObj{
    ClassifyGoodsController *classGoods = [[ClassifyGoodsController alloc]init];
    classGoods.classifyIndex = goodsObj.idNumber ;
    // 这个方法会有一个cell的高度差
//    [self.tabBarController.navigationController pushViewController:classGoods animated:YES];
    
    [self.navigationController pushViewController:classGoods animated:YES];
    
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)refreshTopWithCompletion:(void(^)())completion
{
    
    [[SPNetworkManager sharedClient] getClassifyOfGoodsWithCompletion:^(BOOL succeeded, id responseObject, NSError *error) {
        if(succeeded &&responseObject){
            NSArray *allData = responseObject;
            NSMutableArray *leftArray = [NSMutableArray array];
            NSMutableArray *rightArray = [NSMutableArray array];
            for (ECClassifyGoodsObject * obj in allData) {
                [leftArray addObject:obj];
                [rightArray addObject:obj.classifysArray];
            }
            self.categoryData = leftArray;
            self.productData = rightArray;
            
            // 显示无数据的提示
            if (self.categoryData.count==0) {
                self.categoryData = [NSMutableArray array];
            }
            [self.tableView reloadData];
            
            if (completion) {
                completion();
            }
        }else{
            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"加载失败" message:nil delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//        case 0:
//            NSLog(@"再次加载");
//            [self refreshTopWithCompletion:^{
//                [self.tableView topRefreshControlStopRefreshing];
//            }];
//            break;
//        default:
//            break;
//    }
    
    if (buttonIndex == 0) {
        NSLog(@"再次加载");
        [self refreshTopWithCompletion:^{
            [self.tableView topRefreshControlStopRefreshing];
        }];
    }else{
        
    }
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
