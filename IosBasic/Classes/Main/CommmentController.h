//
//  CommmentController.h
//  IosBasic
//
//  Created by li jun on 17/4/13.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@protocol CommmentControllerDelegate <NSObject>

- (void)updateOrdersList:(NSString *)orderId;

@end

@interface CommmentController : NARootController
@property(nonatomic,weak)id<CommmentControllerDelegate>delegate;
@property(nonatomic,strong)ECOrdersObject *OrdersObj;

@end
