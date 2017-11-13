//
//  ClassifyGoodsController.m
//  IosBasic
//
//  Created by li jun on 16/10/19.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "ClassifyGoodsController.h"
#import "WYMenuClass.h"
#import "UIScrollView+RefreshControl.h"

#import "ClassifyCellViewOne.h"
#import "ClassifyCellViewTwo.h"

#import "GoodsDetailController.h"

#define one_cell_height 120.f
#define two_cell_height 250.f

#define kTable @"Table"
#define kCollect @"Collect"
#import "NACollectionViewCell.h"

#import "EVNCustomSearchBar.h"



@interface ClassifyGoodsController ()<WYMenuClassDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EVNCustomSearchBarDelegate>

//@property (nonatomic, strong) UISearchBar *searchBar;

@property (strong, nonatomic) EVNCustomSearchBar *searchBar;


//  0 默认  1 销量  2 人气  3 价格
@property(nonatomic,strong)NSNumber *sortType;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;

@property(nonatomic)float arrageNum;

@property (nonatomic) WYMenuClass *menu ;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *tableLayout;
@property(nonatomic,strong)UICollectionViewFlowLayout *collectionLayout;
@property(nonatomic)BOOL isTable;


@end

@implementation ClassifyGoodsController

-(UICollectionViewFlowLayout *)tableLayout{
    if (!_tableLayout) {
        _tableLayout = [[UICollectionViewFlowLayout alloc]init];
        _tableLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _tableLayout;
}
-(UICollectionViewFlowLayout *)collectionLayout{
    if (!_collectionLayout) {
        _collectionLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _collectionLayout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, self.view.height - kNavigationHeight) collectionViewLayout:self.tableLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor spBackgroundColor];
    [collectionView registerClass:[NACollectionViewCell class] forCellWithReuseIdentifier:kCollect];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{m_SearchKey_limit:@(self.limits),
                                                                            @"pages":@(self.page)}];
    
    if (self.currentMember) {
        [self.filterDictionary setObject:self.currentMember.id forKey:mC_id];
        [self.filterDictionary setObject:self.currentMember.memberShell forKey:m_member_user_shell];
    }
    
    if (self.classifyIndex) {
        [self.filterDictionary setObject:self.classifyIndex forKey:m_SearchKey_cateid];
    }
    
    if (self.brandId) {
        [self.filterDictionary setObject:self.brandId forKey:@"brandId"];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addTopRefreshControlUsingBlock:^{
        [weakSelf showTipsWithCheckingDataArray:nil];
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
            [weakSelf.collectionView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.collectionView  topRefreshControlStartInitializeRefreshing];
    });
    
    self.wifiTestTriger = YES;
    
//    [self CreatMenu];
    // Do any additional setup after loading the view.
    
    //判断第一次进入，从搜索按钮第一次进入不要查下
    self.isFirstIn =  YES;
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
// 筛选框
- (void)CreatMenu{
    self.menu = [[WYMenuClass alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 40) menuTitleArray:@[@"综合排序"] leftTitleArr:@[@"销量",@"人气"] selectColor:[UIColor redColor] nomolColor:[UIColor spDefaultTextColor]];
    
    NSArray *sortRuleArray=@[@"综合排序",@"价格由低到高",@"价格由高到低",@"好评率"];
    self.menu.delegate=self;
    self.menu.menuDataArray = [NSMutableArray arrayWithObjects:sortRuleArray, nil];
    
    [self.view addSubview:self.menu];
    
    //__weak typeof(self) _self = self;
    
    [self.menu setHandleSelectDataBlock:^(NSString *selectTitle, NSUInteger selectIndex, NSUInteger selectButtonTag) {
        //处理点击下拉菜单
        NSLog(@"%@",[NSString stringWithFormat:@"selectTitle = %@\n selectIndex = @%lu\n selectButtonTag = @%lu",selectTitle,selectIndex,selectButtonTag]);
        // 0 1 2 3  selectIndex
        if (selectIndex == 0) {
            // 默认排序
            [self.filterDictionary removeObjectForKey:m_SearchKey_key];
            [self.filterDictionary removeObjectForKey:m_SearchKey_order];
            
        }else if(selectIndex == 1){
//        价格由低到高
            [self.filterDictionary setObject:@(3) forKey:m_SearchKey_key];
            [self.filterDictionary setObject:@(1) forKey:m_SearchKey_order];
            
        }else if(selectIndex == 2){
            //   价格由高到低
            [self.filterDictionary setObject:@(3) forKey:m_SearchKey_key];
            [self.filterDictionary setObject:@(2) forKey:m_SearchKey_order];
        }else if(selectIndex == 3){
            //   好平路
        }
        [self.filterDictionary removeObjectForKey:m_SearchKey_keyword];
        [self refreshTopWithCompletion:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arrageNum = 0;
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;

    [self addBackButton];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = self.searchBar;
    if (@available(iOS 11.0, *))
    {
        [self.searchBar.heightAnchor constraintLessThanOrEqualToConstant:44].active = YES;
    }
    
    if(self.isFromSearch){
        self.searchBar.text = self.searchWord;
        [self.searchBar resignFirstResponder];
    }
    
    UIBarButtonItem *leftBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrage1_small"] width:25 height:25 target:self   action:@selector(leftarButtonAction)];
    self.navigationItem.rightBarButtonItem = leftBtn;
    
}
- (void)leftarButtonAction{
    UIBarButtonItem *leftBtn ;
    self.isTable = !self.isTable;
    if(self.isTable){
        leftBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrage2_small"] width:25 height:25 target:self   action:@selector(leftarButtonAction)];
        [self.collectionView setCollectionViewLayout:self.tableLayout];
        [self.collectionView registerClass:[NACollectionViewCell class] forCellWithReuseIdentifier: kTable];
    
    }else{
        leftBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrage1_small"] width:25 height:25 target:self   action:@selector(leftarButtonAction)];
       
        
        [self.collectionView setCollectionViewLayout:self.collectionLayout];
        [self.collectionView registerClass:[NACollectionViewCell class] forCellWithReuseIdentifier: kCollect];
    }
  
    [self.collectionView reloadData];

    self.navigationItem.rightBarButtonItem = leftBtn;
}

- (EVNCustomSearchBar *)searchBar
{
//    if (!_searchBar) {
//        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width-30.f, 40.f)];
//        searchBar.barTintColor = [UIColor whiteColor];
//        searchBar.tintColor = [UIColor spThemeColor];
//        searchBar.barStyle = UISearchBarStyleDefault;
//        searchBar.backgroundColor = [UIColor clearColor];
//        searchBar.showsCancelButton = NO;
//        searchBar.placeholder = @"请输入您要搜索的商品";
//        searchBar.delegate = self;
//        [[searchBar.subviews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
//        UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
//        if (txfSearchField && [txfSearchField isKindOfClass:[UITextField class]]) {
//            txfSearchField.backgroundColor = [UIColor spBackgroundColor];
//        }
//        _searchBar = searchBar;
//    }
//    return _searchBar;
    
    if (!_searchBar)
    {
        _searchBar = [[EVNCustomSearchBar alloc] initWithFrame:CGRectMake(0, 20, NAScreenWidth, 44)];
        _searchBar.backgroundColor = [UIColor clearColor]; // 清空searchBar的背景色
        _searchBar.iconImage = [UIImage imageNamed:@"ic_searchImage"];
        _searchBar.iconAlign = EVNCustomSearchBarIconAlignCenter;
        [_searchBar setPlaceholder:@"请输入您要搜索的商品"];  // 搜索框的占位符
        _searchBar.placeholderColor = [UIColor spDefaultTextColor];
        _searchBar.isHiddenCancelButton = YES;
        _searchBar.delegate = self; // 设置代理
        [_searchBar sizeToFit];
    }
    return _searchBar;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isTable) {
        return CGSizeMake(NAScreenWidth, one_cell_height+10);
    }else{
        return CGSizeMake(NAScreenWidth/2-0.5, two_cell_height);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NACollectionViewCell *cell;
    if (self.isTable) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kTable forIndexPath:indexPath];
        // 为了消除实图重叠的现象
        for (UIView *suvView in [cell.contentView subviews]) {
            [suvView removeFromSuperview];
        }
        ClassifyCellViewOne *cellView = [[ClassifyCellViewOne alloc]initWithFrame:CGRectMake(10, 10, NAScreenWidth-20, one_cell_height)];
        cellView.backgroundColor = [UIColor whiteColor];
        cell.customView1 = cellView;
        [cell.contentView addSubview:cellView];
 
    }else{
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCollect forIndexPath:indexPath];
        for (UIView *suvView in [cell.contentView subviews]) {
            [suvView removeFromSuperview];
        }
        ClassifyCellViewTwo *cellView = [[ClassifyCellViewTwo alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, one_cell_height)];
        cell.customView1 = cellView;
        [cell.contentView addSubview:cellView];
    }
    
    if (self.isTable) {
        ClassifyCellViewOne *view = (ClassifyCellViewOne *)cell.customView1;
       [view viewWithModel:self.dataArray[indexPath.row]];

    }else{
        ClassifyCellViewTwo *view = (ClassifyCellViewTwo *)cell.customView1;
        [view viewWithModel:self.dataArray[indexPath.row]];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECGoodsObject *obj = self.dataArray[indexPath.row];
    
    GoodsDetailController *goodsvc = [[GoodsDetailController alloc]init];
    goodsvc.goodsId = obj.idNumber;
    goodsvc.showHome = YES;
//    [self.tabBarController.navigationController pushViewController:goodsvc animated:YES];
    
    [self.navigationController pushViewController:goodsvc animated:YES];

}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Search Bar Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)searchBarTextDidBeginEditing:(EVNCustomSearchBar *)searchBar
{
    __weak typeof(self) weakSelf = self;
    [self.view addShadowCoverWithAlpha:0.3 withTouchAction:^{
        [weakSelf.searchBar resignFirstResponder];
        if (!KIsBlankString(self.searchBar.text)) {
                self.searchWord = self.searchBar.text;
        }
    }];
}

- (void)searchBarCancelButtonClicked:(EVNCustomSearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(EVNCustomSearchBar *)searchBar
{
//    searchBar.showsCancelButton = NO;
    [self.view hideShadow];
//    self.searchBar.text = self.searchWord;
    if (!KIsBlankString(self.searchWord)) {
        self.searchBar.text = self.searchWord;
    }
    
}

- (void)searchBarSearchButtonClicked:(EVNCustomSearchBar *)searchBar
{
    [self.view hideShadow];
    self.searchWord = searchBar.text;
    NSLog(@"搜索的内容是：%@",self.searchWord);
    //    [self refreshTableWithUpdate];
    if (![searchBar.text isEmptyString]) {
        self.searchWord = searchBar.text;
        __weak typeof(self) weakSelf = self;
        [self refreshTopWithCompletion:^{
           [weakSelf showTipsWithCheckingDataArray:weakSelf.dataArray];
        }];
        [self.collectionView reloadData];
    }
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];

}
#pragma mark---UIbutton
- (void)changeCell:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----WYMenuClassDelegate
-(void)segmentView:(WYMenuClass *)segmentView didSelectIndex:(NSInteger)index{
//    NSLog(@"点击到时哪个啊%d",index);
    self.sortType = @(index+1);
    [self refreshTopWithCompletion:^{
        
    }];
    [self.collectionView reloadData];
}
#pragma mark----updata

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
//    [self showLoadingView:YES];
    
    [self refreshTopWithCompletion:^{
        [self showTipsWithCheckingDataArray:self.dataArray];
    }];
}


- (void)refreshTopWithCompletion:(void(^)())completion{
    
     //判断第一次进入，从搜索按钮第一次进入不要查下
    if(self.isFromSearch&&self.isFirstIn){
        [self.searchBar becomeFirstResponder];
        [self.collectionView topRefreshControlStopRefreshing];
        self.isFirstIn = NO;

        return;
    }

    if(self.searchWord){
        [self.filterDictionary setObject:self.searchWord forKey:m_SearchKey_keyword];
    }
    
    if(self.sortType){
        [self.filterDictionary setObject:self.sortType forKey:@"key"];
    }
    
    
    if (self.dataArray.count < self.limits) {
        [self.filterDictionary setObject:@(self.limits) forKey:m_SearchKey_limit];
    }else
        [self.filterDictionary setObject:@(self.dataArray.count) forKey:m_SearchKey_limit];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] goodsWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeeded&&responseObject) {
                    // self.dataArray = nil;
                    // NSArray *filteredArray = [self filterData:responseObject withAllData:self.dataArray];
                    // [self.dataArray addObjectsFromArray:filteredArray];
                    self.dataArray = responseObject;
                    
                    [self.collectionView reloadData];
                }else{
                    self.dataArray = nil;
                    [self.collectionView reloadData];
                    [SVProgressHUD showInfoWithStatus:@"无数据!"];
                }
                
                
                
                if (completion) {
                    completion();
                }
            });
        
            if ([responseObject count] < self.limits) {
                [self.collectionView removeBottomRefreshControl];
            }else
                [self addBottomRefresh];
    }];
}
- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView addBottomRefreshControlUsingBlock:^{
        [weakSelf refreshBottomWith:^{
            [weakSelf.collectionView bottomRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
}
- (void)refreshBottomWith:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] goodsWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
        
            [self.dataArray addObjectsFromArray:responseObject];
            [self.collectionView reloadData];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"已加载到底部!"];
        }
        if (completion) {
            completion();
        }
        if ([responseObject count] < self.limits) {
            [self.collectionView removeBottomRefreshControl];
        }else
            [self addBottomRefresh];
    }];
}
- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
