//
//  SPMember.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/5.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "SPMember.h"
#import "SPNetworkManager.h"

@implementation SPMember

+ (instancetype)currentMember
{
    if ([NADefaults sharedDefaults].currentMemberId) {
       return [SPMember MR_findFirstByAttribute:@"id" withValue:[NADefaults sharedDefaults].currentMemberId];
    }
    return nil;
}

+ (instancetype)getMemberById:(NSString *)memberId{
    return [SPMember MR_findFirstByAttribute:@"id" withValue:memberId];
}


+ (instancetype)saveECMember:(ECMemberObject *)member{
    SPMember *m = [SPMember MR_findFirstByAttribute:@"id" withValue:member.id];
    if (!m) {
        m = [SPMember MR_createEntity];
    }
    m.id = member.id;
    m.memberShell = member.member_user_shell;
    m.name = member.name;
    m.work_num = member.work_num;
    m.token = member.token;
    m.isAccept = member.isAccept;
    m.email = member.email;
    m.phone = member.phone;
   
        // 测试数据
//    m.start_time = @(1511774594);

    
    m.start_time = member.start_time;
    m.end_time = member.end_time;
    m.state = member.state;
    
    MR_SaveToPersitent_For_CurrentThread;
    return  m;
}

+ (void)save{
    MR_SaveToPersitent_For_CurrentThread;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *yearString = [NSString stringWithFormat:@"%ld",(long)year];
    if (year<1000) yearString = [NSString stringWithFormat:@"0%ld",(long)year];
    if (year<100) yearString = [NSString stringWithFormat:@"00%ld",(long)year];
    if (year<10) yearString = [NSString stringWithFormat:@"000%ld",(long)year];
    
    NSString *monthString = [NSString stringWithFormat:@"%ld",(long)month];
    if (month < 10) monthString = [NSString stringWithFormat:@"0%ld",(long)month];
    
    NSString *dayString = [NSString stringWithFormat:@"%ld",(long)day];
    if (day < 10) dayString = [NSString stringWithFormat:@"0%ld",(long)day];
    
    NSString *dateString = [NSString stringWithFormat:@"%@%@%@",yearString,monthString,dayString];
    NALog(@"----- > dateString : %@", dateString);
    return NADateFromString(@"yyyyMMdd", dateString);
    
}


+ (void)updateMemberInfo
{
    if([NADefaults sharedDefaults].currentMemberId){
         NSString *token = @"";
        if ([NADefaults sharedDefaults].deviceToken) {
            token = [NADefaults sharedDefaults].deviceToken;
        }
        // 获取版本号
        NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *params = @{m_name : [NADefaults sharedDefaults].username,
                                 m_password :[NADefaults sharedDefaults].password,
                                 m_token : token,
                                 m_udid:NAGetUDID(),
                                 @"os_type":@"ios",
                                 m_ver:versionString
                                 };
        [[SPNetworkManager sharedClient] loginWithParams:params completion:^(BOOL succeeded, id responseObject ,NSError *error){
            if (succeeded) {
                ECMemberObject *obj = responseObject;
                [SPMember saveECMember:obj];
                [NADefaults sharedDefaults].currentMemberId = obj.id;
            }else
            {
                [NADefaults sharedDefaults].currentMemberId = nil;
                 NSLog(@"error");
            }
             NAPostNotification(kSPLoginStatusChanged, nil);
        }];

    }
    
}



@end
