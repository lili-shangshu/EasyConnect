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

static NSString *const kSisChat = @"kSisChat";
static NSString *const kSisTime = @"kSisTime";

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
@property (nonatomic, strong) NSString * memberShell;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * work_num;

@property (nonatomic, strong) NSString * token;   // 设备token值
@property (nonatomic, strong) NSNumber * isAccept; // 1 接受 2 不接受

@property (nonatomic, strong) NSString * start_time; //
@property (nonatomic, strong) NSNumber * end_time; //

@property (nonatomic, strong) NSNumber * state; // 1 未开始 2 开始了
@property (nonatomic, strong) NSString * working_id; //

// 暂时不用
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;




@property (nonatomic, retain) NSDictionary *updateDataDict;

+ (instancetype)currentMember;

+ (instancetype)getMemberById:(NSString *)memberId;

+ (instancetype)saveECMember:(ECMemberObject *)member;

+ (void)save;

+ (void)updateMemberInfo;

@end
