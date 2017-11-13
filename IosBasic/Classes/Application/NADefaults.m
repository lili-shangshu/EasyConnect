//
//  FGDefaults.m
//  FlyGift
//
//  Created by Nathan Ou on 14/12/16.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "NADefaults.h"

#define kWebviewID @"crzlink_platform"

static NSString *const kFGDeivceUUIDKey = @"kFGDeivceUUIDKey";

static NSString *const kCurrentMemberIDKey = @"kFGCurrentMemberIDKey";
static NSString *const kCurrentMemberID2Key = @"kFGCurrentMemberID2Key";
static NSString *const kFirstLaunchKey = @"kFGFirstLaunchKey";
static NSString *const kMemberUserShellKey = @"kMemberUserShellKey";
static NSString *const kDeviceToken = @"kDeviceToken";
static NSString *const kUsernameKey = @"kFGUsernameKey";
static NSString *const kPasswordKey = @"kFGPasswordKey";
static NSString *const kRememberMeKey = @"kFGRememberMeKey";
static NSString *const kCategoryDataKey = @"kCategoryDataKey";

static NSString *const kCompanyInfoKey = @"kCompanyInfoKey";
static NSString *const kDataInfoKey = @"kDataInfoKey";

static NSString *const kAddressInfoKey = @"kAddressInfoKey";
static NSString *const kTerritoryIdKey = @"kTerritoryIdKey";
static NSString *const kCityIdKey = @"kCityIdKey";
static NSString *const kPhoneKey = @"kPhoneKey";

static NSString *const kSearchRecordInfoKey = @"kSearchRecordInfoKey";

static NSString *const kCartKey = @"kCartKey";

static NSString *const kIsFirstOrder = @"kIsFirstOrder";
static NSString *const kIsAcceptOrder = @"kIsAcceptOrder";
static NSString *const kLang = @"kLang";

// 商城项目
static NSString *const kCartNumber = @"kCartNumber";
static NSString *const kstore_free_price = @"store_free_price";
static NSString *const kpoints_orderrate = @"points_orderrate";


@implementation NADefaults

+ (instancetype)sharedDefaults
{
    static NADefaults *_sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDefaults = [[NADefaults alloc] init];
    });
    return _sharedDefaults;
}

- (void)registerDefaults
{
    [self addCustomUserAgentForWebview];
    NSDictionary *defaults = @{kFirstLaunchKey : @(YES),
                               };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)boolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)integerForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    NSData *data;
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        data = [dictionary NA_dictionaryToNSData];
    }
    [self setObject:data forKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    NSData *data = [self objectForKey:key];
    return [data NA_dataToNSDictionary];
}

- (void)addCustomUserAgentForWebview
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *userAgent=[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    if ([userAgent rangeOfString:kWebviewID].length <= 0 ) userAgent = [NSString stringWithFormat:@"%@ %@", userAgent,kWebviewID];
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",userAgent],
                                  @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Default
////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)cartNumber{
    return[self integerForKey:kCartNumber];
}
-(void)setCartNumber:(NSInteger)cartNumber{
    [self setInteger:cartNumber forKey:kCartNumber];
}
-(NSInteger)points_orderrate{
    return [self integerForKey:kpoints_orderrate];
}
- (void)setPoints_orderrate:(NSInteger)points_orderrate{
    [self setInteger:points_orderrate forKey:kpoints_orderrate];
}

- (BOOL)isRememberMe
{
    return [self boolForKey:kRememberMeKey];
}

- (void)setRememberMe:(BOOL)rememberMe
{
    [self setBool:rememberMe forKey:kRememberMeKey];
}

- (NSString *)lang{
    return [self objectForKey:kLang];
}

- (void)setLang:(NSString *)lang{
    [self setObject:lang forKey:kLang];
}

-(NSString *)store_free_price{
    return [self objectForKey:kstore_free_price];
}
- (void)setStore_free_price:(NSString *)store_free_price{
    [self setObject:store_free_price forKey:kstore_free_price];
}
- (NSString *)username
{
    return [self objectForKey:kUsernameKey];
}

- (void)setUsername:(NSString *)username
{
    [self setObject:username forKey:kUsernameKey];
}

- (NSString *)password
{
    return [self objectForKey:kPasswordKey];
}

- (void)setPassword:(NSString *)password
{
    [self setObject:password forKey:kPasswordKey];
}

- (void)setFirstLaunch:(BOOL)firstLaunch
{
    [self setBool:firstLaunch forKey:kFirstLaunchKey];
}

- (BOOL)isFirstLaunch
{
    return [self boolForKey:kFirstLaunchKey];
}

- (void)setCategoryData:(NSDictionary *)categoryData
{
    NSData *data;
    if (categoryData && [categoryData isKindOfClass:[NSDictionary class]]) {
        data = [((NSDictionary *)categoryData) NA_dictionaryToNSData];
    }
    [self setObject:data forKey:kCategoryDataKey];
}

- (NSDictionary *)categoryData
{
    NSData *data = [self objectForKey:kCategoryDataKey];
    return [data NA_dataToNSDictionary];
}

- (void)setCurrentMemberId:(NSString *)currentMemberId
{
    [self setObject:currentMemberId forKey:kCurrentMemberIDKey];
}

- (NSString *)currentMemberId
{
    return [self objectForKey:kCurrentMemberIDKey];
}

- (void)setCurrentMemberId2:(NSString *)currentMemberId2{
    [self setObject:currentMemberId2 forKey:kCurrentMemberID2Key];
}

- (NSString *)currentMemberId2{
    return [self objectForKey:kCurrentMemberID2Key];
}

- (void)setCompanyInfoDict:(NSDictionary *)companyInfoDict
{
    [self setDictionary:companyInfoDict forKey:kCompanyInfoKey];
}

- (NSDictionary *)companyInfoDict
{
    return [self dictionaryForKey:kCompanyInfoKey];
}

- (NSDictionary *)updateDataDict
{
    return [self dictionaryForKey:kDataInfoKey];
}

- (void)setUpdateDataDict:(NSDictionary *)updateDataDict
{
    [self setDictionary:updateDataDict forKey:kDataInfoKey];
}

- (void)setAddress:(NSString *)address{

    [self setObject:address forKey:kAddressInfoKey];
}

- (NSString *)address{

    return [self objectForKey:kAddressInfoKey];
}

- (void)setTerritoryId:(NSString *)territoryId{
    
    [self setObject:territoryId forKey:kTerritoryIdKey];
}

- (NSString *)territoryId{
    
    return [self objectForKey:kTerritoryIdKey];
}

- (void)setCityId:(NSString *)cityId{
    
    [self setObject:cityId forKey:kCityIdKey];
}

- (NSString *)cityId{
    
    return [self objectForKey:kCityIdKey];
}

- (void)setPhone:(NSString *)phone{
    [self setObject:phone forKey:kPhoneKey];
}

-(NSString *)phone{
    return [self objectForKey:kPhoneKey];
}

- (void)setMemberUserShell:(NSString *)memberUserShell{
    [self setObject:memberUserShell forKey:kMemberUserShellKey];
}

-(NSString *)memberUserShell{
    return  [self objectForKey:kMemberUserShellKey];
}

- (void)setDeviceToken:(NSString *)deviceToken{
    [self setObject:deviceToken forKey:kDeviceToken];
}

-(NSString *)deviceToken{
    return  [self objectForKey:kDeviceToken];
}

- (void)setIsFirstOrder:(NSString *)isFirstOrder{
    [self setObject:isFirstOrder forKey:kIsFirstOrder];
}

- (NSString *)isFirstOrder{
    return [self objectForKey:kIsFirstOrder];
}

- (void)setSearchRecordArray:(NSMutableArray *)searchRecordArray{
    [self setObject:searchRecordArray forKey:kSearchRecordInfoKey];
}

- (NSString *)isAcceptOrder{
    return [self objectForKey:kIsAcceptOrder];
}

- (void)setIsAcceptOrder:(NSString *)isAcceptOrder{
    [self setObject:isAcceptOrder forKey:kIsAcceptOrder];
}

- (NSMutableArray *)searchRecordArray{
    return [self objectForKey:kSearchRecordInfoKey];
}

- (void)removeSearchRecord{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSearchRecordInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCartArray:(NSMutableDictionary *)cartArray{
    [self setObject:cartArray forKey:kCartKey];
}

- (NSMutableDictionary *)cartArray{
    return [self objectForKey:kCartKey];
}

@end
