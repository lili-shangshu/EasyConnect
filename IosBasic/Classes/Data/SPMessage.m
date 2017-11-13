//
//  SPCart.m
//  IosBasic
//
//  Created by junshi on 16/2/25.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "SPMessage.h"

@implementation SPMessage


+ (void)addMessage:(NSString *)mId
{
    SPMessage *m = [SPMessage MR_createEntity];
    m.id = mId;
    
    MR_SaveToPersitent_For_CurrentThread;
    
}



+ (SPMessage *)findById:(NSString *)id{

    NSArray *array = [SPMessage MR_findByAttribute:@"id" withValue:id];
    if(array.count>0)
        return array[0];
    else
        return nil;
}


@end

