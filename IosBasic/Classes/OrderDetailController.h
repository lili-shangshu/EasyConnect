//
//  OrderDetailController.h
//  IosBasic
//
//  Created by li jun on 16/12/15.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface OrderDetailController : NARootController

@property(strong,nonatomic) NSString * orderId ;
@property(strong)NSNumber *pointsAndVouvherFee;
//@property(nonatomic,strong)ECOrdersDetailObject *detailObj;

@property(nonatomic,strong)ECOrdersObject *selectObj;

@end
