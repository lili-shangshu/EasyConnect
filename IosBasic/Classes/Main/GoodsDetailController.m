//
//  GoodsDetailController.m
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "GoodsDetailController.h"

#import "SCNavTabBarController.h"

#import "CommentController.h"
#import "DetailGoodsController.h"
#import "DetailImageController.h"
#import "ShoppingCartController.h"
#import "SPNetworkManager.h"

#import "XTPopView.h"
#import "AppDelegate.h"

#define padding 10
#define textSize 15.f

@interface GoodsDetailController ()<selectIndexPathDelegate>

@property (nonatomic, strong) SCNavTabBarController *scorllVC;
@property(nonatomic,strong)UILabel *cartNumLable;
@property(nonatomic,strong)NSString *htmlString;
@property(nonatomic,strong)UIButton *collectButton;
@property(nonatomic,strong)XTPopView *popView;
//@property(nonatomic,strong)UIView *chooseView;
//@property(nonatomic,strong)UIView *chooseContainView;

@end

@implementation GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 测试数据   100072  
//    self.goodsId = @"100072";
    
    // 获取数据增加到这个里面，再通过block传回来详情的html文件
    DetailGoodsController *goodsVC = [[DetailGoodsController alloc]init];
    goodsVC.goodsId = self.goodsId;
    
    __weak typeof(self) weakSelf = self;
//    goodsVC.commentButtonBlock = ^(){
//        [weakSelf.scorllVC.mainView setContentOffset:CGPointMake(2*NAScreenWidth, 0) animated:YES];
//    };
    goodsVC.collectButtonBlock = ^(NSString *isCollect){
        
        if ([isCollect isEqualToString:@"1"]) {
            weakSelf.collectButton.selected = YES;
        }else{
            weakSelf.collectButton.selected = NO;
        }
        
    };
    goodsVC.title = @"商品";
    
    DetailImageController *imageVC = [[DetailImageController alloc]init];
    goodsVC.delegate = imageVC;
    imageVC.title = @"介绍";

//    CommentController *commemtVC = [[CommentController alloc]init];
//    commemtVC.goodsId = self.goodsId;
//    commemtVC.title = @"评论";
//    self.view.backgroundColor = [UIColor whiteColor];
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] initWithtabBarColor:[UIColor spBackgroundColor]];
    
    navTabBarController.subViewControllers = @[goodsVC,imageVC];

    navTabBarController.selectedIndex = 0;
    navTabBarController.view.top = 0.f;
    navTabBarController.view.height = self.view.height-kTabbarHeight-kNavigationHeight;
    navTabBarController.view.backgroundColor = [UIColor whiteColor];
    
    navTabBarController.navTabBarLineColor = [UIColor redColor];
    
    [navTabBarController addParentController:self];
    self.scorllVC = navTabBarController;
    
    // 底部三个按钮
    [self setbottomView];
    
    // 设置通知中心设置角标的显示。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCart:) name:kSPShopCartChange object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
    
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
    
    self.title = @"商品详情";
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
- (void)setbottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.scorllVC.view.bottom, NAScreenWidth, kTabbarHeight)];
     [self.view addSubview:view];
    UIButton *cartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth/2-20, view.height)];
    [cartButton addTarget:self action:@selector(shopCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cartButton.backgroundColor = [UIColor NA_ColorWithR:59 g:185 b:211];
     [view addSubview:cartButton];
    // 图标
    UIImageView *cartImage = [[UIImageView alloc]initWithFrame:CGRectMake(cartButton.width/2-30, 10, 30, 30)];
    cartImage.image = [UIImage imageNamed:@"white-cart"];
    [cartButton addSubview:cartImage];
    
    // 购物车的角标
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(cartImage.width-12, 0, 12, 12)];
    lable.text = [NSString stringWithFormat:@"%d",[NADefaults sharedDefaults].cartNumber];
    lable.font = [UIFont defaultTextFontWithSize:10];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.layer.cornerRadius = lable.width/2.f;
    lable.layer.masksToBounds = YES;
    lable.clipsToBounds = YES;
    lable.backgroundColor = [UIColor redColor];
    self.cartNumLable = lable;
    if ([NADefaults sharedDefaults].cartNumber == 0||!self.currentMember) {
        lable.hidden = YES;
    }
    [cartImage addSubview:lable];
    
    // 文字
    UILabel *cartLable = [[UILabel alloc]initWithFrame:CGRectMake(cartImage.right+padding, cartImage.top, cartButton.width, 30)];
    [cartLable setLabelWith:@"购物车" color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:textSize-1] aliment:NSTextAlignmentLeft];
    [cartButton addSubview:cartLable];
   

    float buttonwidth = NAScreenWidth/4;
    
    // 收藏
    UIButton *payButton = [[UIButton alloc]initWithFrame:CGRectMake(cartButton.right, 0,buttonwidth , view.height)];
    [payButton setTitle:@"收藏" forState:UIControlStateNormal];
    [payButton setTitle:@"取消收藏" forState:UIControlStateSelected];
    self.collectButton = payButton;
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setBackgroundColor:[UIColor NA_ColorWithR:248 g:217 b:68]];
    payButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize-1];
    [payButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:payButton];
    
    // 加入购物车
    UIButton *addCartButton = [[UIButton alloc]initWithFrame:CGRectMake(payButton.right, 0,buttonwidth+20 , view.height)];
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCartButton setBackgroundColor:[UIColor NA_ColorWithR:238 g:14 b:40]];
    addCartButton.titleLabel.font = [UIFont boldSystemFontOfSize:textSize-1];
    [addCartButton addTarget:self action:@selector(addCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addCartButton];

   
    
   
}
- (void)updateCart:(NSNotification*) aNotification{
    self.cartNumLable.hidden = NO;
    self.cartNumLable.text = [NSString stringWithFormat:@"%ld",[NADefaults sharedDefaults].cartNumber];
    if ([NADefaults sharedDefaults].cartNumber == 0) {
        self.cartNumLable.hidden = YES;
    }
}
#pragma mark ----uibutton
- (void)shopCartButtonClick{
    NSLog(@"跳转到购物车");
    __weak typeof(self) weakSelf = self;
    [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
        if (success) {
            ShoppingCartController *shopCartVC = [[ShoppingCartController alloc]init];
            shopCartVC.isDetail = YES;
            shopCartVC.showHome = YES;
            [weakSelf.navigationController pushViewController:shopCartVC animated:YES];
        }
        
    }];
   
    
}
- (void)addCartButtonClick{
//    NSLog(@"加入购物车");
    [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
        if (success) {
             NAPostNotification(kECShowChoose, nil);
        }
    }];
}

// 收藏
- (void)collectButtonClick:(UIButton *)button{
    [self shouldPresentLoginControllerWithCompletion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            if (!button.selected) {
                
                NSDictionary *dic = @{@"goodsID":self.goodsId,mC_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"typeNum":@1};
                [[SPNetworkManager sharedClient] addToUserCollectWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (succeeded) {
                        [SVProgressHUD showInfoWithStatus:@"收藏成功"];
                        button.selected = !button.selected;
                    }
                }];
                
            }else{
                
                NSDictionary *dic = @{@"goodsID":self.goodsId,mC_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"typeNum":@0};
                [[SPNetworkManager sharedClient] deletaUserCollectWithParams:dic completion:^(BOOL succeeded, id responseObject, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (succeeded) {
                        [SVProgressHUD showInfoWithStatus:@"取消成功"];
                        button.selected = !button.selected;
                    }
                }];
            }
        }
    }];
}

- (void)backBarButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
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
