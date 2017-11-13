//
//  BrandController.m
//  IosBasic
//
//  Created by junshi on 2017/5/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "BrandController.h"
#import "WYMenuClass.h"
#import "UIScrollView+RefreshControl.h"
#import "ClassifyGoodsController.h"
#import "BrandCellView.h"

#define one_cell_height 120.f
#define two_cell_height 140.f

#define kTable @"Table"
#define kCollect @"Collect"
#import "NACollectionViewCell.h"



@interface BrandController ()<UISearchBarDelegate,WYMenuClassDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;

@property(nonatomic)float arrageNum;

@property (nonatomic) WYMenuClass *menu ;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *tableLayout;
@property(nonatomic,strong)UICollectionViewFlowLayout *collectionLayout;
@property(nonatomic)BOOL isTable;


@end

@implementation BrandController

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
                                                                            m_SearchKey_page:@(self.page)}];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addTopRefreshControlUsingBlock:^{
        [weakSelf showTipsWithCheckingDataArray:nil];
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf.collectionView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView  topRefreshControlStartInitializeRefreshing];
    });
    
    
    
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arrageNum = 0;
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    [self addBackButton];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"品牌专区";
    
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
   // if (self.isTable) {
//        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kTable forIndexPath:indexPath];
//        // 为了消除实图重叠的现象
//        for (UIView *suvView in [cell.contentView subviews]) {
//            [suvView removeFromSuperview];
//        }
//        BrandCellView *cellView = [[BrandCellView alloc]initWithFrame:CGRectMake(10, 10, NAScreenWidth-20, one_cell_height)];
//        cellView.backgroundColor = [UIColor whiteColor];
//        cell.customView1 = cellView;
//        [cell.contentView addSubview:cellView];
    
   // }
    
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCollect forIndexPath:indexPath];
    for (UIView *suvView in [cell.contentView subviews]) {
        [suvView removeFromSuperview];
    }
    BrandCellView *cellView = [[BrandCellView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, one_cell_height)];
    cell.customView1 = cellView;
    [cell.contentView addSubview:cellView];
    
    
   
    BrandCellView *view = (BrandCellView *)cell.customView1;
    [view viewWithModel:self.dataArray[indexPath.row]];
  
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECBrandObject *obj = self.dataArray[indexPath.row];
    
    ClassifyGoodsController *svc = [[ClassifyGoodsController alloc]init];
    svc.brandId = obj.brandID;
    [self.navigationController pushViewController:svc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark----updata
- (void)refreshTopWithCompletion:(void(^)())completion{
    
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];

    
    if (self.dataArray.count < self.limits) {
        [self.filterDictionary setObject:@(self.limits) forKey:m_SearchKey_limit];
    }else
        [self.filterDictionary setObject:@(self.dataArray.count) forKey:m_SearchKey_limit];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] brandWithParams:nil completion:^(BOOL succeeded, id responseObject, NSError *error) {
        [SVProgressHUD dismiss];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {

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
    [[SPNetworkManager sharedClient] brandWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject, NSError *error) {
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

@end
