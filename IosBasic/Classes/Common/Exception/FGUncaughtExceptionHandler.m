//
//  FGUncaughtExceptionHandler.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/29.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//
#import "FGUncaughtExceptionHandler.h"

#define kExceptionFileName @"Exception.txt"

NSString *applicationDocumentsDirectory() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
//    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
//                     name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     name,reason,[arr componentsJoinedByString:@"\n"]];
    NALog(@"%@",url);
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:kExceptionFileName];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
//    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
//    NSString *urlStr = [NSString stringWithFormat:@"mailto://tianranwuwai@yeah.net?subject=bug报告&body=感谢您的配合! 错误详情:%@",crashLogInfo];
//    NSURL *url2 = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url2];
    //或者调用某个处理程序来处理这个信息
    
    
}

@implementation FGUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (NSString *)errorString
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",applicationDocumentsDirectory(),kExceptionFileName];
    
    if ([self checkIsPathForFileExited:filePath]) {
        NSString *exceptionString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
        NALog(@"%@",exceptionString);
        return exceptionString;
    }
    
    return nil;
}

+ (BOOL)checkIsPathForFileExited:(NSString *)path
{
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!(!isDir && existed)) {
        NSLog(@"----------> File Path is Not Existed or Cannot find such file for Path : %@",path);
        return NO;
    }
    return YES;
}

+ (void)deleteExceptionList
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",applicationDocumentsDirectory(),kExceptionFileName];
    
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"--------->  File delete ERROR : %@ for Path : %@",error, filePath);
    }else NSLog(@"--------->  File delete succeed! Path : %@", filePath);
}

@end
