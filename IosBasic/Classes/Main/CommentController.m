//
//  CommentController.m
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "CommentController.h"
#import "UIScrollView+RefreshControl.h"
#import "SPStarView.h"

#define padding 10.f
#define button_height  30.f
#define cell_height   100.f
#define lable_height  30.f
#define k_textfont 14.f

@interface CommentController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)float typeNum;
@property(nonatomic,strong)UIImageView *nodataView;



@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor spBackgroundColor];
    // 64  底部的按钮49  44  113
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight-kTabbarHeight-44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.limits = 10;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"goods_id":self.goodsId,m_SearchKey_limit:@(self.limits),m_SearchKey_page:@(self.page)}];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
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
//
-(UIImageView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIImageView alloc]initWithFrame:CGRectMake(NAScreenWidth/3, NAScreenHeight/4, NAScreenWidth/3, NAScreenWidth/3)];
        _nodataView.image = [UIImage imageNamed:@"ic_load_empty.png"];
        _nodataView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshTableWithUpdate)];
        //        tap.numberOfTouches = 1;
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_nodataView addGestureRecognizer:tap];
        
    }
    return _nodataView;
}
- (void)showNodataView:(NSArray *)array{
    
    if (array.count>0&&array) {
        [self.nodataView removeFromSuperview];
    }else{
        [self.view addSubview:self.nodataView];
    }
    
}
- (void)refreshTableWithUpdate
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTopWithCompletion:^{
             [self showTipsWithCheckingDataArray:self.dataArray];
        }];
    });
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
    return cell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"PostReuseID";
    
    NACommenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell cellSetZeroInsets];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, cell_height-10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(padding, 5, 60, 60)];
        avatar.image = [UIImage imageNamed:@"avatar"];
        cell.customImageView = avatar;
        [bgView addSubview:avatar];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, avatar.bottom, 80, 25)];
        [nameLabel setLabelWith:@"" color:[UIColor spThemeColor] font:[UIFont defaultTextFontWithSize:k_textfont-1] aliment:NSTextAlignmentCenter];
        cell.titleLabel = nameLabel;
        [bgView addSubview:nameLabel];
        
        SPStarView *starView = [[SPStarView alloc] init];
        starView.left = avatar.right+padding;
        starView.top = padding;
        cell.starView = starView;
        [bgView addSubview:starView];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right+padding, starView.bottom+padding , bgView.width-avatar.right-2*padding, bgView.height-3*padding-starView.height)];
        commentLabel.numberOfLines = 0;
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [commentLabel setLabelWith:@"" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:k_textfont] aliment:NSTextAlignmentLeft];
        cell.customLabel1 = commentLabel;
        [bgView addSubview:commentLabel];
    }
    
    ECGoodsCommentObject *obj = _dataArray[indexPath.row];
    if (obj.commentAvatar) {
        [cell.customImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.commentAvatar]];
    }
    
    [cell.starView setStarViewWithNumber:obj.score];
    cell.titleLabel.text = obj.commentName;
    cell.customLabel1.text = obj.content;
    return cell;
}
- (void)refreshTopWithCompletion:(void(^)())completion{
    [self.filterDictionary setObject:@(self.typeNum) forKey:@"type"];
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getGoodsCommentWithParams:self.filterDictionary  completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = responseObject;
                [self showNodataView:self.dataArray];
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
            self.dataArray = [NSMutableArray array];
            [self showNodataView:self.dataArray];
            [self.tableView reloadData];
            if (completion) {
                completion();
            }
        }
    }];
    
    
}
- (void)refreshBottomWith:(void(^)())completion
{
        [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
        [[SPNetworkManager sharedClient] getGoodsCommentWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
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
- (NSArray *)filterData:(NSArray *)data withAllData:(NSArray *)allData
{
    NSMutableArray *filteredData = [NSMutableArray array];
    for(ECGoodsCommentObject *object in data) {
        
        BOOL objectCanBeAdded = YES;
        
        for (ECGoodsCommentObject *object2 in allData)
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
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.typeNum = 0;
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
