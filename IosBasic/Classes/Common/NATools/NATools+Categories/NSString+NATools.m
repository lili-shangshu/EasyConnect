//
//  NSString+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-9-18.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

/***  这些都是本人收藏的方法，方便大家开发以及学习。 ****/

#import "NSString+NATools.h"

@implementation NSString (NATools)

+ (NSString *)NA_UUIDString
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    NSString *UUIDString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, UUID);
    CFRelease(UUID);
    // Remove '-' in UUID
    return [[[UUIDString componentsSeparatedByString:@"-"] componentsJoinedByString:@""] lowercaseString];
}

+ (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
// 18位的
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
// 15位和18位两种
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (NSString *)backDateString:(NSDate *)date{
    NSString *dateStr = @"";
    NSDateFormatter *fam = [[NSDateFormatter alloc]init];
    [fam setDateFormat:@"EEEE"];
    NSString *string1 = [fam stringFromDate:date];
    NSLog(@"中文%@",string1);
    if ([string1 isEqualToString:@"星期一"]||[string1 isEqualToString:@"Monday"]) {
        string1 = @"Monday";
    }else if ([string1 isEqualToString:@"星期二"]||[string1 isEqualToString:@"Tuesday"]){
        string1 = @"Tuesday";
    }else if ([string1 isEqualToString:@"星期三"]||[string1 isEqualToString:@"Wednesday"]){
        string1 = @"Wednesday";
    }else if ([string1 isEqualToString:@"星期四"]||[string1 isEqualToString:@"Thursday"]){
        string1 = @"Thursday";
    }else if ([string1 isEqualToString:@"星期五"]||[string1 isEqualToString:@"Friday"]){
        string1 = @"Friday";
    }else if ([string1 isEqualToString:@"星期六"]||[string1 isEqualToString:@"Saturday"]){
        string1 = @"Saturday";
    }else{
        string1 = @"Sunday";
    }
    NSLog(@"星期：%@",string1);
    dateStr  = [dateStr stringByAppendingString:string1];
    dateStr  = [dateStr stringByAppendingString:@","];
    [fam setDateFormat:@"dd"];
    NSString *string = [fam stringFromDate:date];
    NSLog(@"日：%@",string);
    dateStr  = [dateStr stringByAppendingString:string];
    dateStr  = [dateStr stringByAppendingString:@" "];
    [fam setDateFormat:@"MMMM"];
    NSString *string2 = [fam stringFromDate:date];
    NSLog(@"月：%@",string2);
    if ([string2 isEqualToString:@"一月"]||[string2 isEqualToString:@"January"]) {
        string2 = @"January";
    }else if([string2 isEqualToString:@"二月"]||[string2 isEqualToString:@"February"]){
        string2 = @"February";
    }else if([string2 isEqualToString:@"三月"]||[string2 isEqualToString:@"March"]){
        string2 = @"March";
    }else if([string2 isEqualToString:@"四月"]||[string2 isEqualToString:@"April"]){
        string2 = @"April";
    }else if([string2 isEqualToString:@"五月"]||[string2 isEqualToString:@"May"]){
        string2 = @"May";
    }else if([string2 isEqualToString:@"六月"]||[string2 isEqualToString:@"June"]){
        string2 = @"June";
    }else if([string2 isEqualToString:@"七月"]||[string2 isEqualToString:@"July"]){
        string2 = @"July";
    }else if([string2 isEqualToString:@"八月"]||[string2 isEqualToString:@"August"]){
        string2 = @"August";
    }else if([string2 isEqualToString:@"九月"]||[string2 isEqualToString:@"September"]){
        string2 = @"September";
    }else if([string2 isEqualToString:@"十月"]||[string2 isEqualToString:@"October"]){
        string2 = @"October";
    }else if([string2 isEqualToString:@"十一月份"]||[string2 isEqualToString:@"November"]){
        string2 = @"November";
    }else{
        string2 = @"December";
    }
    NSLog(@"月份：%@",string2);
    dateStr  = [dateStr stringByAppendingString:string2];
    NSLog(@"实际需要的是%@",dateStr);
    return dateStr;
}

- (NSString *)hideStringFromRangeToRange:(NSRange)range withString:(NSString *)string
{
    if (range.location+range.length > self.length) {
        if (self.length - range.location > 0) {
            range.length = self.length - range.location;
        }else return self;
    }
    
    if (string.length>1) {
        // Make sure use string length = 1
        string = [string substringToIndex:1];
    }
    NSString *headStr;
    NSMutableString *middleStr = [NSMutableString string];
    NSString *tailStr;
    if (range.location > 0) {
        headStr = [self substringToIndex:range.location];
    }
    
    if ((range.location+range.length) < self.length) {
        tailStr = [self substringFromIndex:range.location+range.length];
    }
    
    for (int i = 0; i < range.length; i++) {
        [middleStr appendString:string];
    }
    
    NSMutableString *targetStr = [NSMutableString string];
    
    if (headStr) [targetStr appendString:headStr];
    if (middleStr) [targetStr appendString:middleStr];
    if (tailStr) [targetStr appendString:tailStr];
    
    return targetStr;
}

//验证email
-(BOOL)isValidateEmail {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}

//验证电话号码
-(BOOL)isValidateTelNumber{
    
    NSString *strRegex = @"[0-9]{1,20}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber{
    NSString *strRegex = @"^1([3-8]\\d)\\d{8}$";
    // 澳洲 10位手机号 中国 11位 
//    NSString *strRegex = @"[0-9]{10,11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}

// 正则判断金额格式
- (BOOL)isValidatePrice{
    // 小数位 2位
    NSString *strRegex = @"^\\d+(\\.\\d{2,5})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPureInt{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}
- (BOOL)isEmptyString
{
    return !self || [@"" isEqualToString:self];
}

- (NSURL *)url
{
    return [NSURL URLWithString:self];
}

@end
