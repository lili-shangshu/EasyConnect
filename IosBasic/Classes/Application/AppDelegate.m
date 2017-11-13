//
//  AppDelegate.m
//  IosBasic
//
//  Created by Nathan Ou on 15/2/27.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "AppDelegate.h"
#import "NANavigationController.h"
#import <PSPDFActionSheet.h>
#import "SVProgressHUD.h"
#import "SPNetworkManager.h"
#import "IQKeyboardManager.h"
#import "FGUncaughtExceptionHandler.h"
#import "SPNetworkManager.h"
#import "SPMember.h"
// Debug

//#import "BraintreeCore.h"
//#import <GoogleMaps/GoogleMaps.h>

#import "MainController.h"
#import "MineController.h"
#import "ShoppingCartController.h"
#import "ClassifyViewController.h"

#import "PushMessageController.h"
#import <Bugly/Bugly.h>


@interface AppDelegate () <UINavigationControllerDelegate>
@property (nonatomic,strong) NANavigationController *navController;

@end

NSString *flag = @"en";
NSString *braintreePaymentsURLScheme = @"com.ozwego.payments";
NSString *facebookURLScheme = @"fb516446135226341";
NSString *wechatURLScheme = @"wx60853248b3416743";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    // 测试数据
    
    NALog(@"-------> Window Width : %f  height : %f", NAScreenWidth, NAScreenHeight);
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self handleRemoteNotifications:userInfo];
    }
    
//    [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypeScreenEdgePan];
    
    
    // Register Database
    [MagicalRecord setDefaultModelNamed:@"StraightPin.momd"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"StraightPin.sqlite"];
    
    [self setupMainControllers];
    
    //设置 SVProgress 颜色
   // [SVProgressHUD setForegroundColor:[UIColor spLightRedColor]];
    
    [Bugly startWithAppId:@"f4d455bd82"];
    
    [[NADefaults sharedDefaults] registerDefaults];
    
    
    
    // google Map service
  //  [GMSServices provideAPIKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"googleMapKey"]];
    
    // 远程推送
    // iOS 9 
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |UIUserNotificationTypeSound);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
//        
//    } else {
//        // Register for Push Notifications before iOS 8
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound)];
//    }
//
//    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    }
    

    
    //获取系统语言
    [self getCurrentLanguage];
    
    [self setupBasicData];
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
//- (BOOL)application:(__unused UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    if ([[url.scheme lowercaseString] isEqualToString:[braintreePaymentsURLScheme lowercaseString]]) {
//        return [BTAppSwitch handleOpenURL:url options:options];
//    }
//    
//    //wechat
//    return [WXApi handleOpenURL:url delegate:self];
//    
//    return YES;
//}
#endif
#pragma mark----银联支付
-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书--通过一次网络请求处理。
    //此处的verify，商户需送去商户后台做验签
    return YES;
}

// Deprecated in iOS 9, version  < 9.0
/*
 * @Summary:程序启动第三方应用
 *
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}

/*
 * @Summary:程序被第三方调用，传入参数启动
 *
 */
- (bool)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    return  YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // 涉及第二次登录的接口
    [SPMember updateMemberInfo];
   
    [self updateVersion];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [MagicalRecord cleanUp];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)setupBasicData{
    [[SPNetworkManager sharedClient]getCityWithCompletion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            NSLog(@"=====获取地址信息完成=======");
        }
    }];

}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)updateVersion
{
    NSDictionary *params = @{@"id":@"ios"};
    // 请求参数是id=ios和android
    [[SPNetworkManager sharedClient] getAppVersion:params completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                [SPVersionObject checkVerionWithDict:responseObject];
            }
        }
    }];
}

- (void)setupMainControllers
{
    // 获取基本数据时，加载数据获取购物车中的商品数，待返回个数后设置购物车显示个数，通过在SPMainTabBarController 中的通知中心 显示。
    NANavigationController *navController = [[NANavigationController alloc] initWithRootViewController:self.mainTabbarController];

    // 这里设置背景色－－－日啊
    [navController applyAppDefaultApprence];
    
    self.window = [[NAWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    [self.window bringSubviewToFront:self.window.splashView];
    
    self.navController = navController;
    
}


-(SPMainTabBarController *)mainTabbarController{
    if (!_mainTabbarController) {
        
        MainController *mainVC = [[MainController alloc]init];
        mainVC.tabBarController.title =  NSLocalizedString(@"tab_home", @"");
        
        ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
        classifyVC.tabBarController.title =  NSLocalizedString(@"my_account", @"");
        
        ShoppingCartController *shopCartVC = [[ShoppingCartController alloc]init];
        shopCartVC.tabBarController.title = NSLocalizedString(@"tab_investment", @"");
        
        MineController *mineVC = [[MineController alloc]init];
        mineVC.tabBarController.title = NSLocalizedString(@"tab_profile", @"");
        
        mainVC.inTabBarController = YES;
        mainVC.inNavController = YES;
        classifyVC.inTabBarController = YES;
        classifyVC.inNavController = YES;
        shopCartVC.inTabBarController = YES;
        shopCartVC.inNavController = YES;
        mineVC.inTabBarController = YES;
        mineVC.inNavController = YES;
        
        
        UITabBarItem *item1 = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"ic_tab_home"] selectedImage:[UIImage imageNamed:@"ic_tab_home"]];
        [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor spThemeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        mainVC.tabBarItem = item1;
        
        UITabBarItem *item2 = [UITabBarItem itemWithTitle:@"分类" image:[UIImage imageNamed:@"ic_tab_classify"] selectedImage:[UIImage imageNamed:@"ic_tab_classify"]];
        [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor spThemeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        classifyVC.tabBarItem = item2;
        
        UITabBarItem *item3 = [UITabBarItem itemWithTitle:@"购物车" image:[UIImage imageNamed:@"ic_tab_cart"] selectedImage:[UIImage imageNamed:@"ic_tab_cart"]];
        [item3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor spThemeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        shopCartVC.tabBarItem = item3;
        
        UITabBarItem *item4 = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"ic_tab_my"] selectedImage:[UIImage imageNamed:@"ic_tab_my"]];
        [item4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor spThemeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        mineVC.tabBarItem = item4;
        
        SPMainTabBarController *tabbarController = [[SPMainTabBarController alloc] init];
        tabbarController.viewControllers = @[mainVC,classifyVC,shopCartVC,mineVC];
        ////// Try
        UITabBar *tabBar = tabbarController.tabBar;
        //设置 tabBar 背景颜色
        [tabBar setBackgroundImage:[[UIColor whiteColor] image]];

        // UITabBarItem 选中item 颜色设置
        tabBar.tintColor = [UIColor spThemeColor];
        tabbarController.selectedIndex = 0;
        tabbarController.customizableViewControllers = nil;
        
        // Navigation
        _mainTabbarController = tabbarController;

    }
    return _mainTabbarController;
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Navigation Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Push Delegate
////////////////////////////////////////////////////////////////////////////////////

#pragma mark 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString:@" " withString:@""] ;

    NSLog(@"device token:%@", pushToken);
    NSLog(@"device token2:%@", deviceToken);
    [NADefaults sharedDefaults].deviceToken = pushToken;
    SPMember *member = [SPMember currentMember];
    if(member){
        NSDictionary *params = @{m_id:member.id,m_lang:[NADefaults sharedDefaults].lang,
                                 m_token:pushToken,m_member_user_shell:member.memberShell};

        [[SPNetworkManager sharedClient] postTokenWithParams:params completion:^(BOOL succeeded, id responseObject ,NSError *error){
            if (succeeded){}else{}
        }];

    }
    
}

#pragma mark 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
    
}

#pragma mark 接收到推送通知之后
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);

    NSDictionary *aps = userInfo[@"aps"];
    PushMessageController *controller = [[PushMessageController alloc] init];
    controller.message = aps[@"alert"];

    [self.navController  pushViewController:controller animated:YES];
}

-(void)handleRemoteNotifications:(NSDictionary *)userInfo {
    // do your stuff
    NSLog(@"%@",userInfo);
}


#pragma mark - 获取当前系统语言
- (void)getCurrentLanguage
{

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if([currentLanguage rangeOfString:@"en"].location != NSNotFound){

        [NADefaults sharedDefaults].lang = @"en";
    }else if([currentLanguage rangeOfString:@"zh"].location != NSNotFound){
        
        [NADefaults sharedDefaults].lang = @"zh-cn";
        
    }
    
}


@end
