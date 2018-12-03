//
//  NSString+NATools.h
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KIsBlankString(str)  [NSString isBlankString:str]

//#define KIsIdentityCard(str)  [NSString checkIdentityCardNo:str]

#define KIsIdentityCard(str)  [NSString accurateVerifyIDCardNumber:str]

@interface NSString (NATools)

+ (instancetype)NA_UUIDString;
+ (BOOL)isBlankString:(NSString *)str;
//验证身份证号码
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

    
- (NSString *)hideStringFromRangeToRange:(NSRange)range withString:(NSString *)string;

+ (NSString *)backDateString:(NSDate *)date;
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber;
//验证电话号码
- (BOOL)isValidateTelNumber;


//验证email
- (BOOL)isValidateEmail;

// 正则判断金额格式
- (BOOL)isValidatePrice;

// 判断字符串是否为空----这个不怎么灵
- (BOOL)isEmptyString;

// 输入是不是 数字
- (BOOL)isPureInt;

// 生成URL
- (NSURL *)url;

@end
