//
//  CollectViewController.m
//  IosBasic
//
//  Created by li jun on 16/10/12.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "CollectViewController.h"
#import "UIScrollView+RefreshControl.h"
#import "GoodsDetailController.h"
#import "SPNetworkManager.h"

#define k_product_height 100.f
#define k_textfont 15.f


@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.limits = 10;
 
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{mC_id:self.currentMember.id,m_SearchKey_limit:@(self.limits),m_SearchKey_page:@(self.page), m_member_user_shell:self.currentMember.memberShell}];
   
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
    
    // Do any additional setup after loading the view.
}
- (void)cancleButtonClicked:(UIButton *)button{
    ECGoodsObject *obj  = _dataArray[button.tag];
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"取消收藏?" message:nil  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alertView show];
    alertView.tag = obj.idNumber.integerValue;
}
// delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
            //YES应该做的事
        case 0:{
            NSDictionary *paramsDict = @{mC_id : self.currentMember.id,
                                         @"goodsID":@(alertView.tag),
                                         m_member_user_shell:self.currentMember.memberShell
                                         };
            __weak typeof(self) weakSelf = self;
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[SPNetworkManager sharedClient] deletaUserCollectWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
//                [SVProgressHUD dismiss];
                if (succeeded) {
                    [iToast showToastWithText:@"取消成功" position:iToastGravityCenter];
//                    [SVProgressHUD showInfoWithStatus:@"取消成功"];
                    [weakSelf refreshTopWithCompletion:nil];
                }
                
            }];
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
    self.title = @"我的收藏";
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
        // t图
        NAImageView *itemImageView = [[NAImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, k_product_height-30, k_product_height-30)];
        cell.itemImageView = itemImageView;
        [bgView addSubview:itemImageView];
        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemImageView.right+10.f, itemImageView.top, bgView.width-itemImageView.width-10.f*3, 40.f)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [titleLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont boldDefaultTextFontWithSize:k_textfont-2] aliment:NSTextAlignmentLeft];
        cell.titleLabel = titleLabel;
        [bgView addSubview:titleLabel];
        // 价格
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+10, titleLabel.width, 20.f)];
        [priceLabel setLabelWith:@"" color:[UIColor redColor] font:[UIFont defaultTextFontWithSize:k_textfont-2] aliment:NSTextAlignmentLeft];
        cell.priceLabel = priceLabel;
        [bgView addSubview:priceLabel];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, priceLabel.top, 80, priceLabel.height)];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
        button.right = bgView.width-10;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"取消收藏" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont defaultTextFontWithSize:k_textfont-4];
        [button addTarget:self action:@selector(cancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.customButton1 = button;
        [bgView addSubview:button];
        
    }
    cell.customButton1.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    ECGoodsObject *cellModel = _dataArray[indexPath.row];
    [cell.itemImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:cellModel.imageUrl]];
     cell.itemImageView.animated = NO;
    cell.titleLabel.text = cellModel.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"$:%.1f",[cellModel.goodsPrice floatValue]];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%d好评",[cellModel.commentsNum intValue]];
    cell.buyNumberLabel.text = [NSString stringWithFormat:@"销量:%d",[cellModel.salesNum intValue] ];
    
    [cell setInsetWithX:0];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECGoodsObject *cellModel = _dataArray[indexPath.row];
    GoodsDetailController *goodsDetailVC = [[GoodsDetailController alloc]init];
    goodsDetailVC.goodsId = cellModel.idNumber;
    goodsDetailVC.showHome = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- 更新数据
- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
    [self refreshTopWithCompletion:^{
        [self showTipsWithCheckingDataArray:self.dataArray];
    }];
    
}

- (void)refreshTopWithCompletion:(void(^)())completion{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] getUserCollectWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        [SVProgressHUD dismiss];
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.dataArray = nil;
//                NSArray *filteredArray = [weakSelf filterData:responseObject withAllData:weakSelf.dataArray];
//                [weakSelf.dataArray addObjectsFromArray:filteredArray];
                
                weakSelf.dataArray = responseObject;

                [weakSelf.tableView reloadData];
                if (completion) {
                    completion();
                }
                NSMutableArray *array  = responseObject;
                if ([array count] < weakSelf.limits) {
                    [weakSelf.tableView removeBottomRefreshControl];
                }else{
                    [weakSelf addBottomRefresh];
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
     __weak typeof(self) weakSelf = self;
        [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
        [[SPNetworkManager sharedClient] getUserCollectWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeeded) {
//                    NSArray *filteredArray = [weakSelf filterData:responseObject withAllData:weakSelf.dataArray];
//                    [weakSelf.dataArray addObjectsFromArray:filteredArray];
                    
                    [weakSelf.dataArray addObjectsFromArray:responseObject];
                    
                    [weakSelf.tableView reloadData];
                }
                if (completion) {
                    completion();
                }
                NSMutableArray *array  = responseObject;
                if ([array count] < weakSelf.limits) {
                    [weakSelf.tableView removeBottomRefreshControl];
                }else
                    [weakSelf addBottomRefresh];
            });
        }];
}

- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
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
    for(ECGoodsObject *object in data) {
        
        BOOL objectCanBeAdded = YES;
        
        for (ECGoodsObject *object2 in allData)
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
