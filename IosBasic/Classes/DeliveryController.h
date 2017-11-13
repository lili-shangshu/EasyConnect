//
//  DeliveryController.h
//  IosBasic
//
//  Created by Star on 2017/6/21.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface DeliveryController : NARootController

@property (nonatomic, strong) void(^selectResultBlock)(ECAddress *obj);

@end
