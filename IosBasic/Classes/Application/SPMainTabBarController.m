//
//  SPMainTabBarController.m
//  IosBasic
//
//  Created by Nathan Ou on 15/2/28.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//



#import "LoginViewController.h"



#import "ShoppingCartController.h"
#import "MineController.h"

#import "SPMainTabBarController.h"
#import "SPNetworkManager.h"
#import "NANumberView.h"
#import "NANavigationController.h"

@interface SPMainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic,strong) NSTimer *checkDataTimer;
@property (nonatomic,strong) UIImageView *outView;
@property (nonatomic,strong) UIButton *inButton;
@property (nonatomic,strong) NANumberView *numberView;
@property (nonatomic,assign) int cuisineNumber;

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIButton *getBtn;
@property (nonatomic,strong) UILabel *payLbl;
@property (nonatomic,strong) UILabel *getLbl;

@end

@implementation SPMainTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 检测是否需要显示登录的
 //  [self shouldPresentLoginControllerWithCompletion];

}

//用不到


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置定时器，定时扫描数据，有新数据就在模块图标上打红点
    self.checkDataTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(checkNewData) userInfo:nil repeats:YES];
    [self checkNewData];
    self.delegate = self;
    
    // 设置通知中心设置角标的显示。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCart:) name:kSPShopCartChange object:nil];
}

- (void)updateCart:(NSNotification*) aNotification{
//         [self.tabBar showBagePont:YES forIndex:3];
    if (self.currentMember) {
        [self.tabBar showBagePont:YES withNum:[NADefaults sharedDefaults].cartNumber forIndex:2];
    }else{
        [self.tabBar showBagePont:NO withNum:[NADefaults sharedDefaults].cartNumber forIndex:2];
    }
}



- (void)checkNewData
{
    if (!self.currentMember) {
        [self.checkDataTimer invalidate];
        self.checkDataTimer = nil;
        return;
    }
}


- (void)dealloc
{
    if (self.checkDataTimer) {
        [self.checkDataTimer invalidate];
        self.checkDataTimer = nil;
    }
   
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[ShoppingCartController class]]) {
        return [self shouldPresentLoginControllerWithCompletion:^(BOOL succeed){
            if (succeed) {
                tabBarController.selectedViewController = viewController;
                [[(ShoppingCartController *)viewController tableView] reloadData];

            }
        }];
    }else if ([viewController isKindOfClass:[MineController class]]){
        return [self shouldPresentLoginControllerWithCompletion:^(BOOL succeed){
            if (succeed) {
                tabBarController.selectedViewController = viewController;
                [[(ShoppingCartController *)viewController tableView] reloadData];
                
            }
        }];
    }
    return YES;
}

- (void)shouldPresentLoginControllerWithCompletion
{

    if (self.currentMember) {
       
    }else
    {
        LoginViewController *loginContoler = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginContoler];
        [self presentViewController:navController animated:YES completion:^{
            
        }];
        
        

    }
}

- (BOOL)shouldPresentLoginControllerWithCompletion:(void(^)(BOOL success))block
{
    if (self.currentMember) {
         return YES;
    }else
    {
        LoginViewController *loginContoler = [[LoginViewController alloc] init];
        loginContoler.loginResultBlock = block;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginContoler];
        [self presentViewController:navController animated:YES completion:^{
            
        }];
        
        
        return NO;
    }
}

@end
