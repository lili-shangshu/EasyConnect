//
//  DetailGoodsController.m
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "GoodsDetailController.h"
#import "CollectViewController.h"
#import "NSObject+YYModel.h"

#import "DetailGoodsController.h"
#import "NAAccesorryView.h"
#import "SDCycleScrollView.h"

#import "MWPhotoBrowser.h"
#import "MWCommon.h"

#import "CartConfirmController.h"
#import "UIScrollView+RefreshControl.h"

#define k_AD @"滚动"
#define k_ad_height 250
#define k_detail @"detail"
#define k_detaile_height 135

#define k_blank @"blank"
#define k_choose_height 35.f
#define k_choose @"choose"
#define k_commentTitle @"商品评论"
#define k_match @"相关搭配"
#define k_aboutTitle @"相关商品"
#define k_height 60.f

#define k_share @"分享"
#define k_share_height 35
#define k_comment @"评论"
#define k_comment_height 100

#define text_font 15.f
#define lable_height  30.f
#define padding 10




@interface DetailGoodsController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>

@property(nonatomic,strong)NSMutableArray *titleArray;

@property(nonatomic,strong)NSArray *goodsImageArray;

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSArray *commentsArray;
@property(nonatomic,strong)NSArray *goodsArray;

@property(nonatomic,strong)UILabel *chooseLable;

@property(nonatomic,strong)UILabel *chooseLable2;// 显示已经选择
@property(nonatomic,strong)UILabel *stockLable;
@property(nonatomic,strong)UILabel *priceLable;  // 弹出框中的价格
@property(nonatomic,strong)UILabel *priceCellLable;  // tableView中的lable
@property(nonatomic,strong)UILabel *priceMarketCellLable;  // tableView中的lable
@property(nonatomic,strong)UILabel *goodsTitalCellLable;  // tableView中的lable

@property(nonatomic,strong)ECGoodsSTockObject *stockobj;
@property(nonatomic,strong)NSString *chooseString;

@property(nonatomic,strong)UIScrollView *scrollView;   // 这个是弹出选择页面的
@property(nonatomic,strong)NSMutableArray *stringArray;
//@property(nonatomic,assign)NSInteger colorInteger;   // 选择的颜色
//@property(nonatomic,assign)NSInteger sizeInteger;   // 选择的尺寸

@property(nonatomic,strong)UILabel *numberLable; // 数量选择器
@property(nonatomic,assign)int goodsNumber;   // 商品数量


@property(nonatomic,strong)UIView *chooseView;
@property(nonatomic,strong)UIView *chooseContainView;

@property(strong,nonatomic) ECGoodsObject * selectGood;
@property(nonatomic,strong)NSString *chooseid;
@property(nonatomic,strong)NSMutableDictionary *chooseDic;

@end

@implementation DetailGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsNumber = 1;
    self.chooseDic = [NSMutableDictionary dictionary];
    self.stringArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - kNavigationHeight-kTabbarHeight-44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    [self.view addSubview:self.tableView];
    
     __weak typeof(self) weakSelf = self;
    [weakSelf.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf refreshTopWithCompletion:^{
            if (!weakSelf.selectGood) {
                [weakSelf showTipsWithCheckingDataArray:nil];
            }
//             [weakSelf showTipsWithCheckingDataArray:@[weakSelf.selectGood]];
             [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView topRefreshControlStartInitializeRefreshing];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showchooseView:) name:kECShowChoose object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadingDataAction:) name:kSPLoginStatusChanged object:nil];
    
    
//    self.titleArray = @[k_AD,k_detail,k_choose,k_blank,k_comment,k_blank,]
    // Do any additional setup after loading the view.
}

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
//    __weak typeof(self) weakSelf = self;
    [self refreshTopWithCompletion:^{
        
    }];
}

- (void)dealloc{
    NSLog(@"怎么不销毁呢");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 下面这个不能使用，因为点击购买后，返回，通知中心就不再执行了。
//- (void)viewDidDisappear:(BOOL)animated{
//     [super viewDidDisappear:animated];
//     [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)initTitle{
    _titleArray = [NSMutableArray arrayWithObjects:k_AD,k_detail,nil];
    // 规格的问题
    if (self.selectGood.goodsTypeOfTitles.count>0) {
        [_titleArray addObject:k_choose];
    }
    // 暂时取消分享，功能未实现
    //[_titleArray addObject:k_share];
    
}
-(NSArray *)commentsArray{
    if (!_commentsArray) {
        CommentModel *model = [[CommentModel alloc]init];
        model.commentName = @"懂你的小明";
        model.commentType = 2;
        model.commentTime = @"2016-12-12";
        model.commentDetaile = @"不评价";
        _commentsArray = @[model];
    }
    return _commentsArray;
}
-(NSArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = @[@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg",@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg"];
    }
    return _goodsArray;
}
-(NSArray *)goodsImageArray{
    if (!_goodsImageArray) {
        _goodsImageArray =@[@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg",@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg"];
    }
    return _goodsImageArray;
}
- (void)refreshTopWithCompletion:(void(^)())completion
{
    
   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.goodsId forKey: @"goodsID"];
    if (self.currentMember) {
       [ params setValue:self.currentMember.id forKey:mC_id];
       [ params setValue:self.currentMember.memberShell forKey:m_member_user_shell];
    }
    [[SPNetworkManager sharedClient] getGoodsDetailWithParams:params completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.selectGood = responseObject;
                [weakSelf.delegate gethtml:weakSelf.selectGood.htmlDetail];
                weakSelf.collectButtonBlock(weakSelf.selectGood.isFavorites);
                [weakSelf initTitle];
                [weakSelf.tableView reloadData];
                 [SVProgressHUD dismiss];
                if (completion) {
                    completion();
                }
            });
            
        }else{
             [SVProgressHUD dismiss];
            if (completion) {
                completion();
            }
        }
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate & DataSource
////////////////////////////////////////////////////////////////////////////////////

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
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:k_AD]) {
        return k_ad_height;
    }else if([title isEqualToString:k_detail]){
        return k_detaile_height;
    }else if ([title isEqualToString:k_choose]){
        return k_choose_height;
    }else if([title isEqualToString:k_share]){
        return k_share_height+15;
    }else{
        return k_height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NACommenCell *cell;
    NSString *title = self.titleArray[indexPath.row];
    NAAccesorryView *accessoryView = [[NAAccesorryView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    accessoryView.accessoryImage = [UIImage imageNamed:@"arrowImage"];
    
    if ([title isEqualToString:k_AD]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_AD];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_AD];
        }
        // 为了消除实图重叠的现象
        for (UIView *suvView in [cell.contentView subviews]) {
            [suvView removeFromSuperview];
        }

//        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, k_ad_height) imageNamesGroup:@[@"0068.jpg",@"0068.jpg",@"0068.jpg"]];
        
        SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(padding, padding, NAScreenWidth-2*padding, k_ad_height-padding) shouldInfiniteLoop:NO imageNamesGroup:nil];
        cycleScrollView3.autoScroll=NO;
        cycleScrollView3.imageURLStringsGroup = self.selectGood.imagesArray;
        cycleScrollView3.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        cycleScrollView3.currentPageDotColor = [UIColor blueA2];
         __weak typeof(self) weakSelf = self;
        cycleScrollView3.clickItemOperationBlock = ^(NSInteger index){
            NSLog(@"image:%d",index);
            [weakSelf tapImage:index];
        };
        [cell.contentView addSubview:cycleScrollView3];
        
    }
    // 商品名 线 价格 数量 四个
    if ([title isEqualToString:k_detail]) {
//        120
        cell = [tableView dequeueReusableCellWithIdentifier:k_detail];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_detail];
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, k_detaile_height)];
            bgView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            // 标题
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, bgView.width-2*padding, 50)];
            [titleLable setLabelWith:@"" color:[UIColor black4] font:[UIFont boldSystemFontOfSize:text_font+1] aliment:NSTextAlignmentLeft];
            titleLable.numberOfLines = 0;
            cell.titleLabel = titleLable;
            self.goodsTitalCellLable = titleLable;
            [bgView addSubview:titleLable];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, titleLable.bottom+3.5, titleLable.width, 1.5)];
            lineView.backgroundColor = [UIColor spThemeColor];
            [bgView addSubview:lineView];
            
            
            // 价格
            UILabel *priceTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom+10, 40, 25)];
            [priceTitleLable setLabelWith:@"价格:" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
            [bgView addSubview:priceTitleLable];
            
            UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(priceTitleLable.right+5, priceTitleLable.top-2, 120, 30)];
            [priceLable setLabelWith:@"" color:[UIColor spThemeColor] font:[UIFont boldSystemFontOfSize:text_font+3] aliment:NSTextAlignmentLeft];
            cell.priceLabel = priceLable;
            self.priceCellLable = priceLable;
            [bgView addSubview:priceLable];
            
            UILabel *yuanjialalbe = [[UILabel alloc]initWithFrame:CGRectMake(priceLable.right+5, priceLable.top, 120, 30)];
            yuanjialalbe.textColor = [UIColor spDefaultTextColor];
            yuanjialalbe.font = [UIFont defaultTextFontWithSize:text_font-2];
            cell.subTitleLabel = yuanjialalbe;
            self.priceMarketCellLable = yuanjialalbe;
            [bgView addSubview:yuanjialalbe];
            
            //数量
            UILabel *numTitlelalbe = [[UILabel alloc]initWithFrame:CGRectMake(priceTitleLable.left,priceTitleLable.bottom+10, priceTitleLable.width, priceTitleLable.height)];
            [numTitlelalbe setLabelWith:@"数量:" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
            [bgView addSubview:numTitlelalbe];
            
            UIButton *minButton = [[UIButton alloc]initWithFrame:CGRectMake(numTitlelalbe.right+10, numTitlelalbe.top+2, 20, 20)];
            [minButton setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
            minButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
            minButton.backgroundColor = [UIColor spThemeColor];
            minButton.tag = 11;
            [minButton addTarget:self action:@selector(numberbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:minButton];
            
            UILabel *numLalbe = [[UILabel alloc]initWithFrame:CGRectMake(minButton.right, minButton.top, minButton.width*1.5, minButton.height)];
            [numLalbe setLabelWith:[NSString stringWithFormat:@"%d",self.goodsNumber] color:[UIColor black4] font:[UIFont defaultTextFontWithSize:text_font-2] aliment:NSTextAlignmentCenter];
            self.numberLable = numLalbe;
            cell.buyNumberLabel = numLalbe;
            [bgView addSubview:numLalbe];
            
            
            UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(numLalbe.right, minButton.top, 20, 20)];
            [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            addButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
            addButton.backgroundColor = [UIColor spThemeColor];
            addButton.tag = 12;
            [addButton addTarget:self action:@selector(numberbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addButton];
        }
        
        cell.titleLabel.text = self.selectGood.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%.2f",[_selectGood.goodsPrice floatValue]];
        [cell.priceLabel sizeToFit];
        cell.priceLabel.height = 30.f;
      
        NSString *oldPrice = [NSString stringWithFormat:@"(市场价：$%.2f)",[_selectGood.marketPrice floatValue]];
        cell.subTitleLabel.text=oldPrice;
        if ([_selectGood.marketPrice floatValue]==0) {
            cell.subTitleLabel.text = @"";
        }
        cell.buyNumberLabel.text = [NSString stringWithFormat:@"%d",self.goodsNumber];
        cell.subTitleLabel.left = cell.priceLabel.right+20;
        
    }
    
    if ([title isEqualToString:k_choose]) {
        //        120
        cell = [tableView dequeueReusableCellWithIdentifier:k_choose];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_choose];
            
            UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, k_choose_height)];
            bgview.backgroundColor =[UIColor whiteColor];
            [cell.contentView addSubview:bgview];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200,25)];
            [lable setLabelWith:@"请选择规格" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
            self.chooseLable = lable;
            [bgview addSubview:lable];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 8, 15)];
            imageView.right = bgview.width-10;
            imageView.image = [UIImage imageNamed:@"arrowImage"];
            [bgview addSubview:imageView];
        }
    }
    
    if ([title isEqualToString:k_share]) {
        cell = [tableView dequeueReusableCellWithIdentifier:k_share];
        if (cell == nil) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_share];
            UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(padding, 0, NAScreenWidth-2*padding, k_share_height)];
            bgview.backgroundColor =[UIColor whiteColor];
            [cell.contentView addSubview:bgview];
            
            UILabel *Titlelalbe = [[UILabel alloc]initWithFrame:CGRectMake(padding,5, 40, 25)];
            [Titlelalbe setLabelWith:@"分享:" color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
            [bgview addSubview:Titlelalbe];
            
            NSArray *imageArray = @[@"qq-share",@"WeChat-share",@"weibo-share"];
            for (int i=0; i<imageArray.count; i++) {
                UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(Titlelalbe.right+10+i*(10+20), Titlelalbe.top+2, 20, 20)];
                [shareButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
                [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [bgview addSubview:shareButton];
            }
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:k_choose]) {
         __weak typeof(self) weakSelf = self;
        [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
            if (success) {
                [weakSelf showchooseView:nil];
            }
        }];
    }
}

- (void)showchooseView:(NSNotification *)sender{

    // 当不需要选择规格时。
    if (self.selectGood.goodsTypeOfTitles.count<=0) {
        [self chooseAddbuttonClick];
        return;
    }
    
    _chooseView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    _chooseView.backgroundColor = [UIColor black1];
    _chooseView.alpha = 0.9;
    
    _chooseContainView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    _chooseContainView.backgroundColor = [UIColor clearColor];
    // 白色背景
    UIView *whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(0, NAScreenHeight/3, NAScreenHeight, NAScreenHeight*2/3)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [_chooseContainView addSubview:whiteBackView];
    // 图
    UIView *imagebackView = [[UIView alloc]initWithFrame:CGRectMake(20, -20, 105, 105)];
    imagebackView.backgroundColor = [UIColor whiteColor];
    [whiteBackView addSubview:imagebackView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 100, 100)];

    [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:_selectGood.imagesArray[0]]];
    [imagebackView addSubview:imageView];
    
    // 3个lable
    UILabel *pricelable = [[UILabel alloc]initWithFrame:CGRectMake(imagebackView.right+10, 25, NAScreenWidth-imagebackView.right-20, 20)];
     NSString *priceString = @"";
    if (self.stockobj) {
        priceString = [NSString stringWithFormat:@"￥:%.2f",[self.stockobj.goodsPrice floatValue]];
    }else{
        priceString = [NSString stringWithFormat:@"￥:%.2f",[_selectGood.goodsPrice floatValue]];
    }
    [pricelable setLabelWith:priceString color:[UIColor blackColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
    self.priceLable = pricelable;
    [whiteBackView addSubview:pricelable];
    
    UILabel *kucunlable = [[UILabel alloc]initWithFrame:CGRectMake(pricelable.left, pricelable.bottom, pricelable.width, 20)];
    NSString *stockString = @"";
    if (self.stockobj) {
        stockString = [NSString stringWithFormat:@"库存:%@",self.stockobj.storeNum];
    }else{
        stockString = [NSString stringWithFormat:@"库存:%d",[_selectGood.goodsStockNum intValue]];
    }
    [kucunlable setLabelWith:stockString color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-3] aliment:NSTextAlignmentLeft];
    [whiteBackView addSubview:kucunlable];
    self.stockLable = kucunlable;
    
    UILabel *numberlable = [[UILabel alloc]initWithFrame:CGRectMake(kucunlable.left, kucunlable.bottom, kucunlable.width, 20)];
    [numberlable setLabelWith:self.chooseString color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font-3] aliment:NSTextAlignmentLeft];
    self.chooseLable2 = numberlable;
    [whiteBackView addSubview:numberlable];
    
    // 取消按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(NAScreenWidth-20-20, 20, 20, 20)];
    [button setImage:[UIImage imageNamed:@"ic_x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackView addSubview:button];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, imagebackView.bottom+10, NAScreenWidth, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [whiteBackView addSubview:lineView];
    
     // 底部按钮

    UIButton *oKButton = [[UIButton alloc]initWithFrame:CGRectMake(0, whiteBackView.height-49, NAScreenWidth, 49)];
    oKButton.backgroundColor = [UIColor spThemeColor];
    [oKButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oKButton.titleLabel.font = [UIFont boldSystemFontOfSize:text_font];
    [oKButton addTarget:self action:@selector(chooseAddbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackView addSubview:oKButton];
    
    // 滚动试图
    float height = whiteBackView.height-49-lineView.bottom;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.bottom, NAScreenWidth, height)];
    [whiteBackView addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSArray *titleArray = _selectGood.goodsTypeOfTitles;
    NSArray *chooseArray = _selectGood.goodsTypes;
    float titleOfY = 0.0;
    for (int i=0; i<titleArray.count; i++) {
        UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(20, titleOfY, NAScreenWidth-40, 40)];
        [titlelable setLabelWith:titleArray[i] color:[UIColor spDefaultTextColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
        [scrollView addSubview:titlelable];
        NSArray *buttonArray = chooseArray[i];
        int width = 0;
        int height = 0;
        int number = 0;
        int han = 0;
        BOOL ischoose = NO;
        NSInteger choosetag = 0;
        NSArray *keyarray = [self.chooseDic allKeys];
        for (NSString *string in keyarray) {
            if ([string integerValue]== i) {
                ischoose = YES;
                choosetag = [self.chooseDic[string] integerValue];
            }
        }
        for (int n =0; n<buttonArray.count; n++) {
            NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            NSDictionary *dic = buttonArray[n];
            button.typeNum = i;
            CGSize titleSize = [self getSizeByString:dic[@"name"] AndFontSize:text_font-2];
            button.tag = [dic[@"id"] integerValue];
            button.buttonTitle = dic[@"name"];
            [button setTitle:dic[@"name"] forState:UIControlStateNormal];
           
            han = han +titleSize.width;
            if (han > NAScreenWidth) {
                han = 0;
                han = han + titleSize.width;
                height++;
                width = 0;
                width = width+titleSize.width;
                number = 0;
                button.frame = CGRectMake(10, titlelable.bottom+40*height, titleSize.width, 20);
                if (n==buttonArray.count-1) {
                    titleOfY = button.y+button.height+10;
                }
                
            }else{
                button.frame = CGRectMake(width+10+(number*10), titlelable.bottom +40*height, titleSize.width, 20);
                width = width+titleSize.width;
                han = button.right+10;
                if (n==buttonArray.count-1) {
                    titleOfY = button.y+button.height+10;
                }
            }
            number++;
            button.layer.borderColor = [[UIColor blackColor] CGColor];
            button.layer.borderWidth = 1;
            [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont defaultTextFontWithSize:text_font-2];
            button.normalColor = [UIColor whiteColor];
            button.selectedColor = [UIColor blackColor];
            if (ischoose&&button.tag == choosetag) {
                button.selected = YES;
            }
            [button addTarget:self action:@selector(colorbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
        }
        
    }

    scrollView.contentSize = CGSizeMake(NAScreenWidth, titleOfY);
    // 动画未生效
    [[UIApplication sharedApplication].keyWindow  addSubview:_chooseView];
    [[UIApplication sharedApplication].keyWindow  addSubview:_chooseContainView];
}

#pragma mark-----自适应button
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont defaultTextFontWithSize:font]} context:nil].size;
    size.width +=10;
    if (size.width<50) {
        size.width = 50;
    }
    return size;
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIbutton
////////////////////////////////////////////////////////////////////////////////////
- (void)shareButtonClicked:(UIButton *)button{
    // 1 QQ 2 wechat 3 weibo
    
}
- (void)colorbuttonClick:(NACommonButton *)button{
    button.selected = !button.selected;
    NSInteger typeNum = button.typeNum;
    NSString *typekey = [NSString stringWithFormat:@"%li",typeNum];
    if (button.selected) {
        // 如果此方法能取出所有的button
        NSArray *buttonArray= [self.scrollView viewsOfClass:[NACommonButton class]];
        for (NACommonButton *commontButton in buttonArray) {
            if (commontButton.typeNum == typeNum && commontButton.tag != button.tag) {
                commontButton.selected = NO;
                 [self.stringArray removeObject:commontButton.buttonTitle];
            }
        }
        [self.chooseDic setValue:@(button.tag) forKey:typekey];
        [self.stringArray addObject:[NSString stringWithFormat:@"%@",button.buttonTitle]];
        self.chooseString= [self stringByArray:self.stringArray];
        self.chooseLable2.text = self.chooseString;
        self.chooseLable.text = self.chooseString;
    }else{
        [self.chooseDic removeObjectForKey:typekey];
        
        [self.stringArray removeObject:button.buttonTitle];
        self.chooseString= [self stringByArray:self.stringArray];
        self.chooseLable2.text = self.chooseString;
        self.chooseLable.text = self.chooseString;
    }
    //
    NSArray *keyArray = [self.chooseDic allKeys];
    if (keyArray.count == _selectGood.goodsTypeOfTitles.count) {
        // 已选择完毕 拼接字符串 显示字体。
        NSArray *array = [self.chooseDic allKeys];
        NSComparator cmptr = ^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        NSArray *brrrr = [array sortedArrayUsingComparator:cmptr];
        NSMutableArray *muarray = [NSMutableArray array];
        for (NSString *string in brrrr) {
            NSString *keystring = [NSString stringWithFormat:@"%d",[self.chooseDic[string] intValue]];
            [muarray addObject:keystring];
            [muarray addObject:@"|"];
        }
        [muarray removeLastObject];
        NSString *stirng = @"";
        for (NSString *sss in muarray) {
            stirng = [stirng stringByAppendingString:sss];
        }
        NSLog(@"%@",stirng);
        // 拼接完成后，找price和 stock
        for (ECGoodsSTockObject *obj in _selectGood.goodStockArray) {
            if ([obj.specValue isEqualToString:stirng]) {
                NSLog(@"价格：%d===库存%@",[obj.goodsPrice intValue],obj.storeNum);
                self.stockobj = obj;
                self.stockLable.text=[NSString stringWithFormat:@"库存:%@",obj.storeNum];
                self.priceLable.text = [NSString stringWithFormat:@"￥:%.2f",[obj.goodsPrice floatValue]];
                self.priceCellLable.text = [NSString stringWithFormat:@"￥:%.2f",[obj.goodsPrice floatValue]];
                [self.priceCellLable sizeToFit];
                self.chooseid = obj.idNumber;
            }
        }
    }
}

- (void)numberbuttonClicked:(UIButton *)button{
    if (button.tag == 11) {
        // jian
        self.goodsNumber--;
    }else{
        self.goodsNumber++;
    }
    if (self.goodsNumber<=0) {
        self.goodsNumber = 1;
         [iToast showToastWithText:@"不能再少了" position:iToastGravityBottom];
        return;
    }
    self.numberLable.text = [NSString stringWithFormat:@"%d",self.goodsNumber];
}
#pragma mark---加入购物车
- (void)chooseAddbuttonClick{
    NSArray *keyArray = [self.chooseDic allKeys];
    if (keyArray.count != _selectGood.goodsTypeOfTitles.count){
        [SVProgressHUD showInfoWithStatus:@"请选择商品属性"];
        return;
    }else{
        // 传递的不是库存的id
        
        
//        stockId
        NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"goodsID":_selectGood.idNumber,@"selectNum":@(self.goodsNumber),
                                                                                       mC_id:self.currentMember.id,
                                                                                       m_member_user_shell:self.currentMember.memberShell
                                                                                       }];
        if (self.stockobj) {
            [mutaDic setObject:self.stockobj.idNumber forKey:@"stockId"];
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SPNetworkManager sharedClient] addToShopCartWithParams:mutaDic completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                self.chooseView.hidden = YES;
                self.chooseContainView.hidden = YES;
                [NADefaults sharedDefaults].cartNumber+=self.goodsNumber;
                // 更新两个角标
                NAPostNotification(kSPShopCartChange, nil);
                // 更新购物车
                NAPostNotification(kSPUpdateCarts, nil);
                [SVProgressHUD showInfoWithStatus:@"成功添加到购物车"];
            }
            
        }];
        NSLog(@"加入购物车数量:%d",self.goodsNumber);
    }
}

- (void)backButtonClick{
    self.chooseView.hidden = YES;
    self.chooseContainView.hidden = YES;
}

- (NSString *)stringByArray:(NSArray *)array{
    NSString *string = @"规格";
    for (NSString *str in array) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    return string;
}

- (void)tapImage:(NSInteger )index
{
    NSArray *imageArray = self.selectGood.imagesArray;
    int count = (int)imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSString *url = imageArray[i];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
    }
    self.imageArray = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    browser.displayActionButton = NO;
    
    [(UINavigationController *)browser.mainWindow.rootViewController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _imageArray.count)
        return [_imageArray objectAtIndex:index];
    return nil;
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
