//
//  FGUncaughtExceptionHandler.h
//  FlyGift
//
//  Created by Nathan Ou on 15/1/29.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGUncaughtExceptionHandler : NSObject {
    
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;
+ (NSString *)errorString;
+ (void)deleteExceptionList;

@end
