//
//  FGDefaults.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/16.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NADefaults : NSObject

@property (nonatomic, strong) NSString *username;   // 登录的名臣，也就是手机号
@property (nonatomic, strong) NSString *password;   // 密码 
@property (nonatomic, assign, getter = isRememberMe) BOOL rememberMe;

@property (nonatomic, strong) NSString *deviceUUID;
@property (nonatomic, strong) NSString *currentMemberId;  //useid
@property (nonatomic, strong) NSString *currentMemberId2;
@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@property (nonatomic, strong) NSDictionary *categoryData;
@property (nonatomic, strong) NSDictionary *companyInfoDict;
@property (nonatomic, strong) NSDictionary *updateDataDict;

@property (nonatomic,strong) NSMutableArray *searchRecordArray;
@property (nonatomic,strong) NSMutableDictionary *cartArray;

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *territoryId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *memberUserShell;

@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,strong) NSString *isFirstOrder;

@property (nonatomic,strong) NSString *isAcceptOrder;

@property (nonatomic,strong) NSString *lang;


// 商城项目
@property (nonatomic, assign) NSInteger cartNumber;

@property (nonatomic, strong) NSString *store_free_price;

@property (nonatomic, assign) NSInteger points_orderrate;


+ (instancetype)sharedDefaults;
- (void)registerDefaults;
- (void)removeSearchRecord;


@end
