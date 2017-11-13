//
//  MainController.m
//  IosBasic
//
//  Created by junshi on 16/8/8.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "MainController.h"
#import "MainSubView.h"
#import "UIScrollView+RefreshControl.h"
#import "SPNetworkManager.h"
#import "QRCodeSannerController.h"

#import "SearchGoodsController.h"
#import "SDCycleScrollView.h"
#import "ClassifyGoodsController.h"
#import "GoodsDetailController.h"

#import "OrdersManagerController.h"
#import "CollectViewController.h"
#import "AboutUSViewController.h"
#import "HelpController.h"

#import "AgentController.h"
#import "AgentApplyController.h"

#import "BrandController.h"

#define  cellHeight1 100
#define  cellHeight2 120
#define button_height 40.f

#define  hotViewHeight 140
#define  newViewHeight 280
#define  otherViewHeight 200

#define  k_AD  @"Ad"
#define  height_AD 140
#define  k_image @"image"
#define  k_blank @"blank"
#define  k_fanction @"function"
#define  k_fanctionHeight 75
#define  height_blank  15
#define  k_View_hot @"viewone"
#define  k_View_new @"viewone1"
#define  k_View_two @"viewtwo"

#define  button_width 30
#define  title_font_size 17
#define  content_font_size 16
#define textSize 15
#define padding 10




@interface MainController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MainSubViewDelegate,UIScrollViewDelegate>


// 数据类型  1 滚动条   2 本周推荐  3 新品推荐   3 各类型的实例
//  1 和后面的都不同  一个数组 数组中有标题 商品

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *bansArray;

@property(nonatomic,strong)NSArray *goodsHotArray;

@property(nonatomic,strong)NSArray *goodsofOtherArray;

@property(nonatomic,strong)NSArray *goodsHotData;
@property(nonatomic,strong)NSArray *goodsNewData;

@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)NSString *MiddelImageView;
@property(nonatomic,strong)UIScrollView *hotScorllView;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight-kTabbarHeight) ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    
    [self updateMemberInfo];
    self.wifiTestTriger = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:NoticeReLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMemberInfo) name:kSPLoginStatusChanged object:nil];
}



- (void)updateMemberInfo{
    

    [self loadDatasForTableViewWithCompletion:^(NSMutableArray *titles){
        //        [self showLoadingView:NO];
        self.titleArray = [NSMutableArray arrayWithArray:titles];
        [self.tableView reloadData];
    }];
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];

}
- (void)reLogin{
    [self shouldPresentLoginControllerWithCompletion:nil];
}

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
    [self showLoadingView:YES];
    [self loadDatasForTableViewWithCompletion:^(NSMutableArray *titles){
        [self showTipsWithCheckingDataArray:self.titleArray];
        self.titleArray = [NSMutableArray arrayWithArray:titles];
        [self.tableView reloadData];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, self.view.width-70.f, 30)];
    button.backgroundColor = [UIColor spBackgroundColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4.f;
    [button addTarget:self action:@selector(searchBarSearchButto) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *iamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    iamgeView.right = button.width-10;
    iamgeView.image = [UIImage imageNamed:@"ic_searchImage"];
    [button addSubview:iamgeView];

    self.tabBarController.navigationItem.titleView = button;
    
  UIBarButtonItem *rightbtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"SP_logo_small"] width:40 height:30 target:self   action:@selector(rightBtnAction)];
  self.tabBarController.navigationItem.leftBarButtonItems = @[rightbtn];
    
    
//    self.navigationItem.leftBarButtonItems = @[logoitem];
    
    //每次进入页面时，刷新首页，更新价格
    [self updateMemberInfo];
}

- (void)loadDatasForTableViewWithCompletion:(void(^)(NSMutableArray *array))block{
    NSMutableArray *titles = [NSMutableArray array];
    
    dispatch_group_t mainLoadingGroup = dispatch_group_create();
    
    // 首页的轮播
    dispatch_group_enter(mainLoadingGroup);
    [[SPNetworkManager sharedClient] getMainBanImagesWithCompletion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded && responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
               self.bansArray = responseObject;
                ECMainBansObject *obj = [self.bansArray lastObject];
                self.MiddelImageView = obj.imageUrl;
            });
        }
        dispatch_group_leave(mainLoadingGroup);
    }];
    // 热门和new
    dispatch_group_enter(mainLoadingGroup);
    NSDictionary *dic = nil;
    if (self.currentMember) {
        dic = @{mC_id:self.currentMember.id,
                m_member_user_shell:self.currentMember.memberShell};
    }
    [[SPNetworkManager sharedClient] getMainHotAndNewGoodsWithParames:dic Completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded && responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *array = responseObject;
                for (int i = 0; i<array.count; i++) {
                    ECHotAndNewGoodsObject *obj = array[i];
                    if (i == 0) {
                        self.goodsHotData = obj.goodsArray;
                    }else{
                        self.goodsNewData = obj.goodsArray;
                    }
                }
            });
        }
        dispatch_group_leave(mainLoadingGroup);
    }];
    
    // 分类的--暂不显示了
//    dispatch_group_enter(mainLoadingGroup);
//    [[SPNetworkManager sharedClient] getMainOthersGoodsWithCompletion:^(BOOL succeeded, id responseObject, NSError *error) {
//        if (succeeded && responseObject) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.goodsofOtherArray = responseObject;
//            });
//        }
//        dispatch_group_leave(mainLoadingGroup);
//    }];
    
    
    dispatch_group_notify(mainLoadingGroup, dispatch_get_main_queue(), ^{
        
        [titles addObject:k_AD];
        [titles addObject:k_fanction];
        [titles addObject:k_View_hot];
        [titles addObject:k_image];
        [titles addObject:k_View_new];
//        [titles addObject:k_View_two];

        if (block) {
            block(titles);
        }
    });
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark----UItalbeViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.titleArray[indexPath.row];
    if ([string isEqualToString:k_AD]||[string isEqualToString:k_image]) {
        return height_AD;
    }else if([string isEqualToString:k_fanction]){
        return k_fanctionHeight+10;
    }else if([string isEqualToString:k_View_hot]){
        float height = button_height;
        height+=padding+28;
        height += (NAScreenWidth-4*padding)/3; // image
        height+=(NAScreenWidth-4*padding)/3/3;  // 标题
        height+=(NAScreenWidth-4*padding)/3/3/2;  // 价格
        
        return height;

    }else if([string isEqualToString:k_View_new]){
        
        float height = (NAScreenWidth-4*padding)/3; // image
        height+=(NAScreenWidth-4*padding)/3/3;  // 标题
        height+=(NAScreenWidth-4*padding)/3/3/2;  // 价格
        height+=padding; // 整体的高度
        
        float cellHeiht = 0;
        NSInteger num = self.goodsNewData.count/2;
        cellHeiht=(height*num);
//      height+=height;// 两个
        cellHeiht+=button_height; // 标题
        return  cellHeiht;
//        return button_height+newViewHeight;
    }else{
//       return otherViewHeight+button_height;
        float height = (NAScreenWidth-4*padding)/3; // image
        height+=height/4;  // lable;
        height+=padding;// padd
        height+=  (NAScreenWidth-4*padding)/3; // 下面的两个
        height+=padding;
        height+=button_height; // 标题
        return  height+20;  // 20 按钮高增加10 留下图片下的空白
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:k_AD]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:k_AD];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_AD];
        }
        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, height_AD) imageURLStringsGroup:[self bannerImages]];
        cycleScrollView3.pageDotColor = [UIColor whiteColor];
        cycleScrollView3.currentPageDotColor = [UIColor spThemeColor];
        cycleScrollView3.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        cycleScrollView3.clickItemOperationBlock = ^(NSInteger index){
            [self bannerButtonAction:index];
        };
        cycleScrollView3.autoScrollTimeInterval = 4.0f;
        [cell.contentView addSubview:cycleScrollView3];
    }
    
    if ([title isEqualToString:k_fanction]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_fanction];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_fanction];
            NSArray *titalArray = @[@"品牌专区",@"全部分类",@"我的收藏",@"我的订单"];
            NSArray *imageArray = @[@"f_pin",@"f_fen",@"f_shou",@"f_ding",@"f_shou"];
            NSArray *colorArray = @[[UIColor NA_ColorWithR:52 g:162 b:194],[UIColor NA_ColorWithR:229 g:78 b:105],[UIColor NA_ColorWithR:238 g:129 b:6],[UIColor NA_ColorWithR:158 g:210 b:74]];
            
            float paddd = (NAScreenWidth-4*50)/5;
            for (int i =0; i<4; i++) {
                int leftt =  i%4;
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(paddd+leftt*(paddd+50), (i/4)*75+10, 50, 75)];
                button.tag = i;
                [button addTarget:self action:@selector(fanctionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UIButton *imagbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 50)];
                [imagbutton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
                imagbutton.tag = i;
                [imagbutton addTarget:self action:@selector(fanctionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                imagbutton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                imagbutton.backgroundColor = colorArray[i];
                imagbutton.layer.masksToBounds = YES;
                imagbutton.layer.cornerRadius = imagbutton.width/2;
                [button addSubview:imagbutton];
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, imagbutton.bottom, imagbutton.width, 20)];
                [lable setLabelWith:titalArray[i] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-3] aliment:NSTextAlignmentCenter];
                [button addSubview:lable];
            }
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if ([title isEqualToString:k_View_hot]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_View_hot];
        float itemWidth = (NAScreenWidth-4*padding)/3;
        float scrollViewHeight = itemWidth;
        scrollViewHeight +=itemWidth/3;
        scrollViewHeight +=itemWidth/6;
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_View_hot];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, NAScreenWidth-40, button_height-10)];
            [lable setLabelWith:@"嗨爆热销" color:[UIColor red2] font:[UIFont boldSystemFontOfSize:textSize] aliment:NSTextAlignmentLeft];
            cell.titleLabel = lable;
            [cell.contentView addSubview:lable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lable.left, lable.bottom+4, lable.width, 1)];
            lineView.backgroundColor = [UIColor red2];
            [cell.contentView addSubview:lineView];
            
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10,lineView.bottom+10, NAScreenWidth-padding *2, scrollViewHeight)];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentSize = CGSizeMake((padding+itemWidth)*self.goodsHotData.count, scrollView.height);
            scrollView.bounces = NO;
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            self.hotScorllView = scrollView;
            cell.mainScrollView = scrollView;
            scrollView.tag =100;
            [cell.contentView addSubview:scrollView];
            
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.frame = CGRectMake(0, scrollView.bottom+10,  cell.frame.size.width, 8);//指定位置大小
            pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
            //添加委托方法，当点击小白点就执行此方法
            _pageControl = pageControl;
            pageControl.pageIndicatorTintColor = [UIColor spBackgroundColor];// 设置非选中页的圆点颜色
            pageControl.currentPageIndicatorTintColor = [UIColor spThemeColor]; // 设置选中页的圆点颜色
            [cell.contentView addSubview:pageControl];
           
            cell.backgroundColor = [UIColor whiteColor];
        }
//        _pageControl.numberOfPages = self.goodsHotData.goodsArray.count-2;
        
        // 页数为
        _pageControl.numberOfPages = self.goodsHotData.count/3;
        if (self.goodsHotData.count%3) {
            _pageControl.numberOfPages+=1;
        }
        
        for (UIView *suvView in [cell.mainScrollView subviews]) {
            [suvView removeFromSuperview];
        }
        for (int i=0; i<self.goodsHotData.count; i++) {
            ECGoodsObject *obj = self.goodsHotData[i];
            
            UIButton *itemView = [[UIButton alloc] initWithFrame:CGRectMake(i*(itemWidth+padding), 0, itemWidth, scrollViewHeight)];
            itemView.tag = [obj.idNumber integerValue];
            [itemView addTarget:self action:@selector(hotGoodsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.mainScrollView addSubview:itemView];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, itemView.width, itemWidth)];
            [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.imageUrl]];
            [itemView addSubview:imageView];
            
            UILabel *nameLalbe = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom, imageView.width, itemWidth/3)];
            [nameLalbe setLabelWith:obj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-4] aliment:NSTextAlignmentCenter];
            nameLalbe.numberOfLines = 0;
            [itemView addSubview:nameLalbe];
            
            UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLalbe.bottom, nameLalbe.width, itemWidth/6)];
            [priceLable setLabelWith:[NSString stringWithFormat:@"$%.2f",[obj.goodsPrice floatValue]]color:[UIColor red2] font:[UIFont boldSystemFontOfSize:textSize-1] aliment:NSTextAlignmentCenter];
            [itemView addSubview:priceLable];
        }
    }
    
    if ([title isEqualToString:k_image]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:k_image];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_image];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, height_AD)];
            
            imageView.image = [UIImage imageNamed:@"main_lay"];
            cell.customImageView = imageView;
            [cell.contentView addSubview:imageView];
        }
        if (self.MiddelImageView) {
            [cell.customImageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:self.MiddelImageView]];
        }
    }
    
    if ([title isEqualToString:k_View_new]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_View_new];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_View_new];
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-40, button_height)];
            [lable setLabelWith:@"新品速递" color:[UIColor spDefaultTextColor] font:[UIFont boldSystemFontOfSize:textSize] aliment:NSTextAlignmentLeft];
            lable.tag = 1;
            [cell.contentView addSubview:lable];
            
        }
        for (UIView *suvView in [cell.contentView subviews]) {
            if (suvView.tag!=1) {
                [suvView removeFromSuperview];
            }
        }
        
        float itemViewHeight = (NAScreenWidth-4*padding)/3; // image
        float buttonHeight = itemViewHeight ;
        buttonHeight+=itemViewHeight/3;  // 标题
        buttonHeight+=itemViewHeight/6;  // 价格
        
        float Buttonwidth = (NAScreenWidth-30)/2;
        float num  = 0;
        if (self.goodsNewData.count%2 == 1){
            num = self.goodsNewData.count-1;
        }else{
            num = self.goodsNewData.count;
        }
        
        for (int i=0; i<num; i++) {
            ECGoodsObject *obj = self.goodsNewData[i];
            
            UIButton *itemView = [[UIButton alloc] initWithFrame:CGRectMake((i%2)*(10+Buttonwidth)+10,(i/2)*(buttonHeight+10)+button_height , Buttonwidth, buttonHeight)];
            itemView.tag = [obj.idNumber integerValue];
            itemView.backgroundColor =[UIColor whiteColor];
            [itemView addTarget:self action:@selector(newGoodsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:itemView];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((itemView.width-itemViewHeight)/2, 0, itemViewHeight, itemViewHeight)];
            [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.imageUrl]];
            [itemView addSubview:imageView];
            
            UILabel *nameLalbe = [[UILabel alloc]initWithFrame:CGRectMake(0 , imageView.bottom, itemView.width, itemViewHeight/3)];
            [nameLalbe setLabelWith:obj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-2] aliment:NSTextAlignmentCenter];
            nameLalbe.numberOfLines = 0;
            [itemView addSubview:nameLalbe];
            
            UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(nameLalbe.left, nameLalbe.bottom, nameLalbe.width, itemViewHeight/6)];
            [priceLable setLabelWith:[NSString stringWithFormat:@"$%.2f",[obj.goodsPrice floatValue]]color:[UIColor red2] font:[UIFont boldSystemFontOfSize:textSize-1] aliment:NSTextAlignmentCenter];
            [itemView addSubview:priceLable];
        }
    }

    // 显示热门分类 暂时不显示出来
    if ([title isEqualToString:k_View_two]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_View_two];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_View_two];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, NAScreenWidth-40, button_height)];
            [lable setLabelWith:@"热门分类" color:[UIColor spDefaultTextColor] font:[UIFont boldSystemFontOfSize:textSize] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:lable];
            lable.tag = 1;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        for (UIView *suvView in [cell.contentView subviews]) {
            if (suvView.tag!=1) {
                 [suvView removeFromSuperview];
            }
        }
        //3个并排
        // 高为100 宽为100
        float itemWidth = (NAScreenWidth-4*padding)/3;
        for (int i =0;i<3 ; i++) {
            ECClassifyGoodsObject *obj = self.goodsofOtherArray[i];
            UIButton *itemView = [[UIButton alloc] initWithFrame:CGRectMake(i*(padding+itemWidth)+padding, button_height, itemWidth, itemWidth+itemWidth/5+10)];
            itemView.tag = [obj.idNumber integerValue];
            itemView.backgroundColor =[UIColor whiteColor];
            [itemView addTarget:self action:@selector(categoryButtonCick:) forControlEvents:UIControlEventTouchUpInside];
            itemView.layer.masksToBounds = YES;
            itemView.layer.borderWidth = 1;
            itemView.layer.borderColor = [[UIColor spBackgroundColor]CGColor];
            [cell.contentView addSubview:itemView];
            
            UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemView.width, itemWidth/4)];
            [titlelable setLabelWith:obj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-1] aliment:NSTextAlignmentCenter];
            [itemView addSubview:titlelable];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, titlelable.bottom, itemWidth, itemWidth)];
            [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.imageUrl2]];
            [itemView addSubview:imageView];
        }
        
        float buttonWidth = (NAScreenWidth-3*padding)/2;

        for (int i =0;i<2 ; i++) {
            ECClassifyGoodsObject *obj = self.goodsofOtherArray[i+3];
            UIButton *itemView = [[UIButton alloc] initWithFrame:CGRectMake(i*(padding+buttonWidth)+padding,  button_height+itemWidth*6/5+20, buttonWidth-2, itemWidth-2+10)];
            itemView.tag = [obj.idNumber integerValue];
            itemView.backgroundColor =[UIColor whiteColor];
            [itemView addTarget:self action:@selector(categoryButtonCick:) forControlEvents:UIControlEventTouchUpInside];
            itemView.layer.masksToBounds = YES;
            itemView.layer.borderWidth = 1;
            itemView.layer.borderColor = [[UIColor spBackgroundColor]CGColor];
            [cell.contentView addSubview:itemView];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, itemWidth, itemWidth)];
            imageView.right = itemView.width;
            [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:obj.imageUrl2]];
            [itemView addSubview:imageView];
            
            UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, itemView.height)];
            [titlelable setLabelWith:obj.name color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:textSize-1] aliment:NSTextAlignmentLeft];
           
            
            if (i==1) {
                titlelable.font  = [UIFont defaultTextFontWithSize:textSize-3];
                titlelable.width+=10;
            }else{
                 [titlelable sizeToFit];
            }
            
            titlelable.height = itemView.height;
            [itemView addSubview:titlelable];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)refreshTopWithCompletion:(void(^)())completion{
    [self loadDatasForTableViewWithCompletion:^(NSMutableArray *titles){
        self.titleArray = [NSMutableArray arrayWithArray:titles];
        [self.tableView reloadData];
        if (completion) {
            completion();
        }
    }];
}
- (NSArray *)bannerImages{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.bansArray.count-1; i++) {
        ECMainBansObject *object = self.bansArray[i];
         [array addObject:object.imageUrl];
    }
//    for (ECMainBansObject *object in self.bansArray) {
//        [array addObject:object.imageUrl];
//    }
    return array;
}
#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (scrollView.tag == 100) {
        CGPoint offset = scrollView.contentOffset;
        // 未生效-----咋办
//         float itemWidth = (NAScreenWidth-4*padding)/3+padding;
//      if (offset.x / itemWidth == 1) {
//          scrollView.contentOffset = CGPointMake(itemWidth*2, 0);
//      }
//        NSLog(@"%.1f",offset.x);
//        NSLog(@"%.1f",offset.x / scrollView.width);
//        [_pageControl setCurrentPage:offset.x / itemWidth];
        // 调整这个宽度
        [_pageControl setCurrentPage:offset.x / scrollView.width];
    }
}

#pragma mark ---UIbutton Clicked
- (void)fanctionButtonClick:(UIButton *)button{
    NSArray *titalArray = @[@"品牌专区",@"全部分类",@"购物车",@"我的订单",@"我的收藏",@"帮助中心",@"联系我们",@"代理商"];
    NSLog(@"%@",titalArray[button.tag]);
    
    if(button.tag == 0){
        BrandController *conb = [[BrandController alloc] init];
        [self.navigationController pushViewController:conb animated:YES];
        return;
    }
    
    if (button.tag==1) {
        self.tabBarController.selectedIndex = 1;
        return;
    }
    
    if (button.tag ==2) {
        CollectViewController *conV = [[CollectViewController alloc]init];
        [self.navigationController pushViewController:conV animated:YES];
    }
    if (button.tag ==3) {
        OrdersManagerController *conV = [[OrdersManagerController alloc]init];
        [self.navigationController pushViewController:conV animated:YES];
    }
}
- (void)categoryButtonCick:(UIButton *)button{
//    NSLog(@"类别按钮===%ld",button.tag);
//    ClassifyGoodsController *controller = [[ClassifyGoodsController alloc] init];
//    controller.classifyIndex = button.tag;
//    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)bannerButtonAction:(NSInteger)index{
    
//    ECMainBansObject *object = self.bansArray[index];
//    ClassifyGoodsController *controller = [[ClassifyGoodsController alloc] init];
//    controller.classifyIndex = [object.idNumber integerValue];
//    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)searchBarSearchButto{
 //   SearchGoodsController *controller = [[SearchGoodsController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
    
    ClassifyGoodsController *controller = [[ClassifyGoodsController alloc] init];
    controller.isFromSearch = YES;
    [self.tabBarController.navigationController pushViewController:controller animated:YES];
   
}
- (void)leftBtnAction{
    QRCodeSannerController *controller = [[QRCodeSannerController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)rightBtnAction{
//    [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
//        MessageCenterController *controller = [[MessageCenterController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
//    }];
   
}

- (void)hotGoodsButtonClicked:(UIButton *)button{
    GoodsDetailController *controller = [[GoodsDetailController alloc] init];
    controller.goodsId = [NSString stringWithFormat:@"%d",button.tag];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)newGoodsButtonClicked:(UIButton *)button{
    GoodsDetailController *controller = [[GoodsDetailController alloc] init];
    controller.goodsId = [NSString stringWithFormat:@"%d",button.tag];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
