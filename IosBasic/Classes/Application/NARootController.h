//
//  NARootController.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/2.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Reachability.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SPNetworkManager.h"

#define kHomeName @"www.baidu.com"

#define kIsTransulat 0

#define kTransulatInset 64


typedef NS_ENUM(NSInteger, NATipViewType)
{
    NATipViewType_Wifi_Error = 0,
    NATipViewType_No_Data,
};

@interface NARootController : UIViewController

@property (nonatomic, strong) UITapGestureRecognizer *backgroundTap;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) NACommenView *tipView;

@property (nonatomic, strong) NSString *emtyDataTip;
@property (nonatomic, strong) NSString *wifiErrerTip;

@property (nonatomic, assign) BOOL inTabBarController;
@property (nonatomic, assign) BOOL inNavController;

@property (nonatomic, assign) BOOL wifiTestTriger;

- (void)addBackgroundTapAction; // 添加Background Tap
- (void)backgroundTapAction:(id)sensor;

- (void)reloadingDataAction:(id)sender;

//- (void)showLoading

- (void)showTipsWithCheckingDataArray:(NSArray *)dataArray;

- (void)showTipsWithCheckingDataArray:(NSArray *)dataArray with:(float)top;
- (void)showTipView:(BOOL)show withType:(NATipViewType)type;

- (void)showLoadingView:(BOOL)show;
- (void)showWifiErrorView:(BOOL)show;

// Login
- (void)shouldPresentLoginControllerWithCompletion:(void(^)(BOOL success))block;

- (void)hideKeyBoard;


@end
