//
//  SPMember.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/5.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString *const kSPUpdateMemberInfo = @"kSPUpdateMemberInfo";
static NSString *const kSPUpdateCarts = @"kSPUpdateCarts";
static NSString *const kSPOperationPoints = @"kSPOperationPoints";
static NSString *const kSPLoginStatusChanged = @"kSPLoginStatusChanged";
static NSString *const kSPPay = @"kSPPay";
static NSString *const kSPHideKeyboard = @"hideKeyboard";

static inline NSString * genderStringFrom(int gender)
{
    if (gender == 1){
        return @"男";
    }else if(gender == 2){
        return @"女";
    }
    else return @"保密";
}


@interface SPMember : NSManagedObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;  //登录名
@property (nonatomic, strong) NSString * nickName;   // 昵称
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * points; // 用户的积分
@property (nonatomic, strong) NSString * memberShell;

//新增
@property (nonatomic, strong) NSNumber * totalCost; // 累计消费
@property (nonatomic, strong) NSNumber * level;  // 用户的级别
@property (nonatomic, strong) NSString * levelStr;  // 用户的级别
@property (nonatomic, strong) NSNumber * levelScale; // 积分兑换比例
@property (nonatomic, strong) NSNumber * balanceNum; // 预存款－余额

@property (nonatomic, strong) NSNumber * memberRole; // 是否为代理商。 1是推广商  -1审核中。0默认


// 以下参数显示订单的相关信息暂时不使用
@property (nonatomic, strong) NSNumber * noPayNum;
@property (nonatomic, strong) NSNumber * noSendNum;
@property (nonatomic, strong) NSNumber * noReceiveNum;
@property (nonatomic, strong) NSNumber * noEvalNum;

// 以下参数未使用
@property (nonatomic, strong) NSString * ownCode;
@property (nonatomic, strong) NSString * safeCode;

@property (nonatomic, strong) NSNumber * baseMoney;

// Not Really a Property
@property (nonatomic, retain) NSString * address;

@property (nonatomic, retain) NSDictionary *updateDataDict;

+ (instancetype)currentMember;

+ (instancetype)getMemberById:(NSString *)memberId;

+ (instancetype)saveECMember:(ECMemberObject *)member;
+ (instancetype)saveMember:(MemberObject *)member;

+ (void)save;

+ (void)updateMemberInfo;

@end
