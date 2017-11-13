//
//  NARootController.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NARootController.h"

#import "LoginViewController.h"

#define kWifiTip @"网络异常，点击重试"
#define kEmptyTip @"无数据"

#define kLoadingInset (3.f/7.f)

@interface NARootController ()

@property (nonatomic, strong) UIImage *wifiImage;
@property (nonatomic, strong) UIImage *noDataImage;

@end

@implementation NARootController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wifiTestTriger = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showLoadingView:NO];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
//    if (self.tableView)
//    {
//        self.tableView.scrollsToTop = YES;
//    }
    if (self.tableView && ![self.tableView.separatorColor isEqual:[UIColor clearColor]]) {
        self.tableView.separatorColor = [UIColor spSeparatorColor];
    }
    
    if (self.wifiTestTriger) {
        if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
            [self showWifiErrorView:YES];
        }
    }
}

- (void)updateContentInset
{
//    [self performSelector:@selector(setTableViewContentOffset) withObject:nil afterDelay:0.0];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
  //  [self setTableViewContentOffset];
}

- (void)setTableViewContentOffset
{
    if (!self.tableView) {
        return;
    }
    
    CGFloat top = 0;
    CGFloat bottom = 0;
    //状态栏
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    bottom = rectStatus.size.height;
    
//    if (kIsTransulat) {
        if (self.inNavController) bottom += self.tabBarController.navigationController.navigationBar.height;
        if (self.inTabBarController) bottom += self.tabBarController.tabBar.height;
//    }else{
//        if (self.inTabBarController) bottom = 49.f;
//    }
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.tableView) {
//        self.tableView.scrollsToTop = NO;
//    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Tools
////////////////////////////////////////////////////////////////////////////////////

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *containorView = [[UIView alloc] init];
        containorView.backgroundColor = [UIColor clearColor];
        
        UIImageView *spinnerView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loading1"] imageWithColor:[UIColor lightGrayColor]]];
        spinnerView.size = CGSizeMake(20, 20);
        spinnerView.contentMode = UIViewContentModeScaleAspectFit;
        spinnerView.clipsToBounds = YES;
        spinnerView.layer.masksToBounds = YES;
//        spinnerView.alpha = 0.8f;
        [self rotateView:spinnerView];
        
        [containorView addSubview:spinnerView];
        
        UILabel *label = [[UILabel alloc] init];
        [label setLabelWith:@"Loading..." color:[UIColor lightGrayColor] font:[UIFont defaultTextFontWithSize:15.f] aliment:NSTextAlignmentCenter];
        [label sizeToFit];
        label.y = spinnerView.height/2.f;
        label.left = spinnerView.right+10.f;
        [containorView addSubview:label];
        
        containorView.width = label.width+spinnerView.width+10.f;
        containorView.height = MAX(label.height, spinnerView.height);
        [containorView centerAlignHorizontalForView:_loadingView];
        [label centerAlignVerticalForView:containorView];
        [spinnerView centerAlignVerticalForView:containorView];
        containorView.y = _loadingView.height * kLoadingInset-40.f;
        [_loadingView addSubview:containorView];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = _loadingView.bounds;
//        [button addTarget:self action:@selector(reloadingDataAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_loadingView addSubview:button];
        
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)rotateView:(UIView *)view
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.85;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"RotationKey"];
}

- (void)showTipView:(BOOL)show withType:(NATipViewType)type
{
    if (type == NATipViewType_No_Data) {
        self.tipView.imageView.image = self.noDataImage;
        NSString *string = kEmptyTip;
        if (self.emtyDataTip) string = self.emtyDataTip;
        self.tipView.titleLabel.text =  string;
    }
    
    if (type == NATipViewType_Wifi_Error) {
        self.tipView.imageView.image = self.wifiImage;
        NSString *string = kWifiTip;
        if (self.wifiErrerTip) string = self.wifiErrerTip;
        self.tipView.titleLabel.text = string;
    }
    
    self.tipView.hidden = !show;
    if (!self.tipView.hidden) {
        [self.view bringSubviewToFront:self.tipView];
    }
}

- (NACommenView *)tipView
{
    if (!_tipView) {
        
        
//        _tipView = [[NACommenView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
        
        _tipView = [[NACommenView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight)];
        
        
        _tipView.backgroundColor = [UIColor whiteColor];
        
        CGFloat padding = 20.f;
        
        UIView *containor = [[UIView alloc] init];
        containor.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width*(1.f/3.f), self.view.width*(1.f/3.f))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.x = self.view.width/2.f;
        _tipView.imageView = imageView;
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+padding, self.view.width, 20.f)];
        [tipsLabel setLabelWith:@"" color:[UIColor lightGrayColor] font:[UIFont defaultTextFontWithSize:15.f] aliment:NSTextAlignmentCenter];
        _tipView.titleLabel = tipsLabel;
        
        containor.size = CGSizeMake(self.view.width, imageView.height+padding+tipsLabel.height);
        [containor addSubview:imageView];
        [containor addSubview:tipsLabel];
        
        containor.y = _tipView.height*kLoadingInset;
        [_tipView addSubview:containor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _tipView.bounds;
        [button addTarget:self action:@selector(reloadingDataAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tipView addSubview:button];
        [self.view addSubview:_tipView];
        
        
    }
    return _tipView;
}

- (UIImage *)wifiImage
{
    if (!_wifiImage) {
        _wifiImage = [UIImage imageNamed:@"ic_load_error.png"];
    }
    return _wifiImage;
}

- (UIImage *)noDataImage
{
    if (!_noDataImage) {
        _noDataImage = [UIImage imageNamed:@"ic_load_empty.png"];
    }
    return _noDataImage;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////

// Backgroung Tap
- (void)addBackgroundTapAction
{
    if (!self.backgroundTap) {
        self.backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction:)];
        [self.view addGestureRecognizer:self.backgroundTap];
    }
}

- (void)backgroundTapAction:(id)sensor
{
    // 子类实现
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)reloadingDataAction:(id)sender
{
    // 子类实现，最好实现父类，控制loadingView的出现和消失
    [self showLoadingView:YES];
}

- (void)showTipsWithCheckingDataArray:(NSArray *)dataArray
{
    if (self.wifiTestTriger) {
        if (![[Reachability reachabilityWithHostName:kHomeName] isReachable]) {
            [self showWifiErrorView:YES];
            return;
        }
    }
    
    [self showLoadingView:NO];
    if (dataArray) {
        [self showTipView:!(dataArray.count > 0) withType:NATipViewType_No_Data];
    }else
        self.tipView.hidden = YES;
}

- (void)showLoadingView:(BOOL)show
{
    self.loadingView.hidden = !show;
    if (!self.loadingView.hidden) {
        [self.view bringSubviewToFront:self.loadingView];
    }
}

- (void)showWifiErrorView:(BOOL)show
{
    [self showTipView:show withType:NATipViewType_Wifi_Error];
}

- (void)shouldPresentLoginControllerWithCompletion:(void(^)(BOOL success))block
{
    if (self.currentMember) {
           block(YES);
    }else
    {
        LoginViewController *loginContoler = [[LoginViewController alloc] init];
        loginContoler.loginResultBlock = block;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginContoler];
        [self presentViewController:navController animated:YES completion:^{
            if (block) {
                 block(NO);
            }
        }];
    }
}

- (void)hideKeyBoard{
    //统一收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
