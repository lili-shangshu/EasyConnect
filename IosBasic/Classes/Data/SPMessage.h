//
//  SPCart.h
//  IosBasic
//
//  Created by junshi on 16/2/25.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SPMessage : NSManagedObject

@property (nonatomic, strong) NSString *id;


+ (void)addMessage:(NSString *)mId;
+ (SPMessage *)findById:(NSString *)id;

@end