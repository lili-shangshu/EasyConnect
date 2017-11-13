//
//  CartComfirmThirdController.h
//  IosBasic
//
//  Created by li jun on 17/4/15.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface CartComfirmThirdController : NARootController
@property(strong,nonatomic) ECAddress * selectAddress ;
@property(strong,nonatomic) NSString * orderNum ; // 订单号
@property(nonatomic) NSInteger payType;  // 0 银联 1支付宝 2 微信
@property(strong,nonatomic)ECOrdersObject *orderObject;

@property(strong,nonatomic) NSString * orderId ;

@property(nonatomic,strong)ECOrdersDetailObject *detailObj;

@property(nonatomic)BOOL isOrderpay;

@end
