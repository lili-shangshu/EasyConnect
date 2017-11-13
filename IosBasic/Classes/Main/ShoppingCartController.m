//
//  ShoppingCartController.m
//  IosBasic
//
//  Created by li jun on 16/10/14.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShopCartCellView.h"
#import "CartConfirmController.h"
#import "UIScrollView+RefreshControl.h"
#import "NSObject+YYModel.h"
#import "GoodsDetailController.h"
#import "AdressViewController.h"

#import "XTPopView.h"
#import "AppDelegate.h"


#define cell_height 130.f
#define vertical_padding 10.f
#define herizon_padding 20.f
#define text_font 15.f

@interface ShoppingCartController ()<UITableViewDataSource,UITableViewDelegate,ShopCartCellDelegate,UIAlertViewDelegate,selectIndexPathDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UILabel *totalLabel;
@property (nonatomic,strong) UILabel *pointLable;
@property(nonatomic,strong)XTPopView *popView;
@property(nonatomic)float total;

@end

@implementation ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initCartArray];
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49 - kNavigationHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.isDetail) {
        self.tableView.height += 49.f;
    }
    
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.limits = 10;
    self.selectArray = [NSMutableArray array];
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{m_SearchKey_limit:@(self.limits),
        m_SearchKey_page:@(self.page)
        }];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadingDataAction:) name:kSPUpdateCarts object:nil];
    
    // Do any additional setup after loading the view.
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
    
    self.selectArray = [NSMutableArray array];
      __weak typeof(self) weakSelf = self;
    [self refreshTopWithCompletion:^{
         [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
//    UIBarButtonItem *postItem = [UIBarButtonItem NA_BarButtonWithtitile:@"删除" titleColor:[UIColor spDefaultTextColor] target:self action:@selector(deletaButtonAction)];
//    self.tabBarController.navigationItem.rightBarButtonItems = @[postItem];
    
    self.tabBarController.title=@"购物车";
    self.navigationController.navigationBarHidden = NO;
    
    if (_showHome) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
        [button setImage:[UIImage imageNamed:@"back_home"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
        //    UIEdgeInsetsMake(CGFloat top, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        [button addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.width = button.width;
        button.height = 44.f;
        UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightbtn;
    }
}
- (void)rightBtnAction:(UIButton *)sender{
    
    NSArray  *classfyArray = @[@"返回首页"];
    CGPoint point = CGPointMake(sender.left+sender.width/2 , sender.bottom);
    XTPopView *view1 = [[XTPopView alloc] initWithOrigin:point Width:100 Height:40*classfyArray.count Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    view1.dataArray = classfyArray;
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor blackColor];
    view1.delegate = self;
    _popView = view1;
    [_popView popView];
}
- (void)selectIndexPathRow:(NSInteger )index{
    [_popView dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.mainTabbarController.selectedIndex = 0;
    //    self.tabBarController.selectedIndex = 0;
    return;
    
}
#pragma mark----UIButton



- (void)submitButtonAction:(id)sender{
   
    if (self.selectArray.count==0) {
        [iToast showToastWithText:@"请选择商品" position:iToastGravityBottom];
        return;
    }
   
    NSString  *goodsID = @"";
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (NSString *goodsId in self.selectArray) {
        for (ECGoodsObject *obj in self.dataArray) {
            if ([goodsId isEqualToString:obj.idNumber]) {
                [goodsArray addObject:obj];
                goodsID = [goodsID stringByAppendingString:obj.cartsId];
                goodsID = [goodsID stringByAppendingString:@","];
            }
        }
    }
    
    // 下单后没有清楚 selectArray,再次下单会崩
    CartConfirmController *cartVC = [[CartConfirmController alloc]init];
    cartVC.cartsArray = goodsArray;
    cartVC.showHome = _showHome;
    
    NSMutableString *str = [NSMutableString stringWithString:goodsID];
    [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
    NSLog(@"拼接的====%@",str);
    cartVC.goodsID = str;
    [self.navigationController pushViewController:cartVC animated:YES];
    
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
    return _dataArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NACommenCell *cell = nil;
    if (indexPath.row == _dataArray.count) {
        // 这个是合计
        cell =  [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cuisine1"];
        
        UILabel *totallable = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, NAScreenWidth-100, 40)];
        [totallable setLabelWith:@"" color:[UIColor red2] font:[UIFont defaultTextFontWithSize:15] aliment:NSTextAlignmentLeft];
        _totalLabel = totallable;
        
        float sum = 0;
        for(int i = 0 ;i<self.selectArray.count ; i++){
            for (ECGoodsObject *object in self.dataArray) {
                if ([object.idNumber isEqualToString:self.selectArray[i]]) {
                    sum = sum + [object.goodsPrice floatValue]*[object.selectNum floatValue];
                }
            }
        }
        self.total = sum;
        if (sum>0) {
            _totalLabel.text = [NSString stringWithFormat:@"合计:$%.2f",sum];
        }else{
            _totalLabel.text = @"";
        }
        
        [cell.contentView addSubview:totallable];
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, _totalLabel.bottom, NAScreenWidth-20, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_Button"] forState:UIControlStateNormal];
        [button setTitle:@"前往结算" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont defaultTextFontWithSize:15];
        [button addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (_dataArray.count == 0) {
            button.hidden = YES;
            _totalLabel.hidden = YES;
            _pointLable.hidden = YES;
        }else{
            button.hidden = NO;
            _totalLabel.hidden = NO;
            _pointLable.hidden = NO;
        }
        [cell.contentView addSubview:button];
    }else{
        cell= [tableView dequeueReusableCellWithIdentifier:@"cuisine"];
        ECGoodsObject *object = _dataArray[indexPath.row];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cuisine"];
            ShopCartCellView *view = [[ShopCartCellView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, cell_height)];
            view.index = indexPath.row;
            cell.customView1 = view;
            [cell.contentView addSubview:view];
            view.delegate = self;
        }
        ShopCartCellView *view = (ShopCartCellView *)cell.customView1;
        view.titleLabel.text = object.name;
        [view.imgView setImageWithFadingAnimationWithURL:[NSURL URLWithString:object.imageUrl]];
        view.priceLabel.text = [@"$:" stringByAppendingString:[NSString stringWithFormat:@"%.2f",[object.goodsPrice floatValue] ]] ;
        view.numLabel.text = [NSString stringWithFormat:@"%d",[object.selectNum intValue]];
        
        BOOL isslect = NO;
        for (NSString *objId in self.selectArray) {
            if ([objId isEqualToString:object.idNumber]) {
                isslect = YES;
            }
        }
        
        view.selectButton.selected = isslect;
        if (isslect) {
            view.selectimgView.image =  [UIImage imageNamed:@"circle_selected"];
        }else{
            view.selectimgView.image =  [UIImage imageNamed:@"circle_unselected"];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ECGoodsObject *cellModel = _dataArray[indexPath.row];
//    GoodsDetailController *goodsDetailVC = [[GoodsDetailController alloc]init];
//    goodsDetailVC.goodsId = cellModel.idNumber;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    
}
#pragma mark------UItableView Cell Delegate
// 删除
- (void)deleteButtonClicked:(int)index{
    ECGoodsObject *object = self.dataArray[index];
    NSString *cardid =object.cartsId;
    NSDictionary *paramsDict = @{mC_id : self.currentMember.id,
                                 m_member_user_shell:self.currentMember.memberShell,
                                 @"cardsID":cardid
                                 };
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] deleteCartsGoodsWithParams:paramsDict completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            [_dataArray removeObject:object];
            [_selectArray removeObject:object.idNumber];
            [self.tableView reloadData];
            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [self setBagePoint];
            [SVProgressHUD showInfoWithStatus:@"删除成功"];
        }
    }];
    NSLog(@"delete");
}
// 改变数量
- (void)clickIndex:(int)index isAdd :(BOOL)isAdd isSelect:(BOOL)isSelect{
    ECGoodsObject *obj = _dataArray[index];
    int count = [obj.selectNum intValue] ;
    if (isAdd) {
        count ++ ;
    }else{
        if(count>1){
            count -- ;
        }else{
        
            [iToast showToastWithText:@"数量不能少于1" position:iToastGravityBottom];
            return;
        }
    }
    obj.selectNum =  [NSNumber numberWithInt:count];
    NSNumber *selectNum = [NSNumber numberWithInt:count];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *dic = @{mC_id:self.currentMember.id,
                          m_member_user_shell:self.currentMember.memberShell,
                          @"selectNum":selectNum,
                          @"cardsID":obj.cartsId};
    [[SPNetworkManager sharedClient] changeCartsNumWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [_dataArray replaceObjectAtIndex:index withObject:obj];
            [self.tableView reloadData];
             [self setBagePoint];
            [SVProgressHUD dismiss];
            
        }
    }];
}

// 选中
- (void)selectByIndex:(int)buttonTag isSlect:(BOOL)isSelct{
    ECGoodsObject *obj = _dataArray[buttonTag];
    if (isSelct) {
        // 加入
        [self.selectArray addObject:obj.idNumber];
    }else{
        [self.selectArray removeObject:obj.idNumber];
    }
    [self updateTotal];
}
- (void)updateTotal{
    
    float sum = 0;
    for(int i = 0 ;i<self.selectArray.count ; i++){
        for (ECGoodsObject *object in self.dataArray) {
            if ([object.idNumber isEqualToString:self.selectArray[i]]) {
                 sum = sum + [object.goodsPrice floatValue]*[object.selectNum floatValue];
            }
        }
    }
    self.total = sum;
    if (sum>0) {
         _totalLabel.text = [NSString stringWithFormat:@"合计:$%.2f",sum];
    }else{
        _totalLabel.text = @"";
    }
   
    
}
- (void)setBagePoint{

    int totalNumber = 0;
    float sum = 0;
    int sum1 = 0;
    
    for(int i = 0 ;i<self.dataArray.count ; i++){
        ECGoodsObject *object = self.dataArray[i];
        sum = sum + [object.goodsPrice intValue]*[object.selectNum intValue];
        sum1 = sum1 + [object.goodsPrice intValue]*[object.selectNum intValue];
        totalNumber += [object.selectNum intValue];
    }
    self.total = sum;
    _totalLabel.text = [NSString stringWithFormat:@"合计:$%.2f",sum];
    _pointLable.text = [NSString stringWithFormat:@"积分:%d",sum1];
    // 角标的设置
    [NADefaults sharedDefaults].cartNumber = totalNumber;
    [self.tabBarController.tabBar showBagePont:YES withNum:totalNumber forIndex:2];
    // 更新两个角标
    NAPostNotification(kSPShopCartChange, nil);
}
// 当改变选中的数量时 这里的obj的selct的数量还是加入的时候的个数---

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

// 暂时分页功能没有实现。
- (void)refreshTopWithCompletion:(void(^)())completion
{
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    [self.filterDictionary setObject:self.currentMember.id forKey:mC_id];
    [self.filterDictionary setObject:self.currentMember.memberShell forKey:m_member_user_shell];
    [[SPNetworkManager sharedClient] getUsersShopCartWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            // Did Finish Loading
            //            [self updatePullToRefreshStringWithArray:responseObject];
            
            if (succeeded) {
//                self.dataArray = nil;
//                NSArray *filteredArray = [self filterData:responseObject withAllData:self.dataArray];
//                [self.dataArray addObjectsFromArray:filteredArray];
                
                self.dataArray = responseObject;
                [self setBagePoint];
                [self.tableView reloadData];
            }
            if (completion) {
                completion();
            }
            if ([responseObject count] < self.limits) {
                [self.tableView removeBottomRefreshControl];
            }else
                [self addBottomRefresh];
        });
    }];
}

- (void)refreshBottomWith:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [self.filterDictionary setObject:self.currentMember.id forKey:m_id];
    [self.filterDictionary setObject:self.currentMember.memberShell forKey:m_member_user_shell];
    [[SPNetworkManager sharedClient]getUsersShopCartWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){        dispatch_async(dispatch_get_main_queue(), ^{
            // Did Finish Loading
            //            [self updatePullToRefreshStringWithArray:responseObject];
            
            if (succeeded) {
                 [self.dataArray addObjectsFromArray:responseObject];
                [self.tableView reloadData];
                
            }
            if (completion) {
                completion();
            }
            if ([responseObject count] < self.limits) {
                [self.tableView removeBottomRefreshControl];
            }else
                [self addBottomRefresh];
        });
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
