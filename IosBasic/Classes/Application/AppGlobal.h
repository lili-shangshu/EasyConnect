//
//  AppGlobal.h
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "MagicalRecord.h"
#import "Additions+Headers.h"

#import "NATools+Headers.h"
#import "NADefaults.h"
#import "SPCommonObjects.h"
#import "iToast.h"

// Data
#import "SPMember.h"

// MR Operation
#define MR_SaveToPersitent_For_CurrentThread [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait]

/////// Utility
#define IS_IPAD    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480.0f)
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568.0f)
#define IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height == 667.0f)
#define IS_IPHONE6_PLUS ([UIScreen mainScreen].bounds.size.height == 736.0f)

#define NAScreenWidth [[UIScreen mainScreen] bounds].size.width
#define NAScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kDefautCellHeight 45.f

#define kDefaultCellActualHeight 90
#define kSectionHeight kDefautCellHeight*(20.f/90.f)
#define kAccountCellHeight 96.f

#define kNARoundRectRadius 2.5f

#define kBlankCell @"BlankCell"
#define kBlankCellTwice @"kBlankCellTwice"
#define kAllCate @"全部"
#define kAllCateId -10001
#define kCateAll @"查看全部"

#define kTabbarHeight 49.f
#define kNavigationHeight 64.f


// 分享的App Key
#define WeChatAppID @"wxe3c3fd9cbb12596a"
#define QQAppId @"1104573776"

#ifdef DEBUG
#define NALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NALog(...)
#endif

#pragma mark -
//地址更新信号量
static NSString *const kSPAddressUpdate = @"kSPAddressUpdate";


// 理财产品变化
static NSString *const NoticeProduct = @"NoticeProduct";
// 重新登录
static NSString *const NoticeReLogin = @"NoticeReLogin";
//  更新首页
static NSString *const NoticeUpdateHome = @"NoticeUpdateHome";
// 更新用户
static NSString *const NoticeLoginChange = @"NoticeLoginChange";
// 指纹支付
static NSString *const NoticeFingerPay = @"NoticeFingerPay";

// 指纹提现
static NSString *const NoticeFingerWithdraw = @"NoticeFingerWithdraw";

static NSString *const kSPWeChatLogin = @"kSPWeChatLogin";

#pragma mark----ECShop

// 角标的变化---详情页里面的购物车角标变化
static NSString *const kSPShopCartChange = @"kSPShopCartChange";
// 显示选择页面
static NSString *const kECShowChoose = @"kECShowChoose";

static NSString *const kECCollectShop = @"kECCollectShop";

static inline NSInteger NARandomInteger(NSInteger lower, NSInteger upper) {
  
    return (arc4random() % (upper - lower) + lower);
}

static inline CGFloat NARandomFloat(CGFloat lower, CGFloat upper) {
    return ((float) arc4random() / 0x100000000) * (upper - lower) + lower;
}

static inline NSString *NAStringFromDate(NSString *dateFormat, NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

static inline NSDate *NADateFromString(NSString *dateFormat, NSString *dateString) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}

static inline void NAPostNotification(NSString *notificationName, id sensor) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:sensor];
    });
}

static inline NSString * NAGetPhoneVesionString()
{
    if (IS_IPAD) return @"IPad";
    if (IS_IPHONE4) return @"IPhone4";
    if (IS_IPHONE5) return @"IPhone5";
    if (IS_IPHONE6) return @"IPhone6";
    if (IS_IPHONE6_PLUS) return @"IPhone6_Plus";
    return @"Unkown Device";
}

static inline NSString * NAGetUDID(){
   
    return  [UIDevice currentDevice].identifierForVendor.UUIDString;
}

static inline NSString * NAGetImgBaseUrl(){

    NSString *serverString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SeverString"];
    serverString = [serverString stringByAppendingString:@"data/upload/"];
    return serverString;
}

static NSString *const tNetworkException = @"Network Unavailable";
static NSString *const tNameEmpty = @"Enter name";
static NSString *const tEmailEmpty = @"Enter email";
static NSString *const tPasswordEmpty = @"Enter password";
static NSString *const tRepassordEmpty = @"Enter password";
static NSString *const tPhoneEmpty = @"Enter phone number";
static NSString *const tAddressEmpty = @"Enter address";
static NSString *const tPasswordNoMatch = @"Twice passwod does not match";

// 默认用词
#define kDefaultUsername @"暂无"




