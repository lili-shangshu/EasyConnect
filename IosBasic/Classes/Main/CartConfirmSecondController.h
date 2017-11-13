//
//  CartConfirmSecondController.h
//  IosBasic
//
//  Created by li jun on 17/4/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface CartConfirmSecondController : NARootController
@property(strong,nonatomic)NSArray *ordersArray;
@property(strong,nonatomic) ECAddress * selectAddress ; // 需要在第三个页面显示出来
//@property(strong,nonatomic) NSMutableDictionary * sendDic;
@property(strong,nonatomic)NSString *paysn;
@property(nonatomic)float totalMoney;  // 货物的金额
@property(nonatomic)float discountMoney;  //实际支付金额

//@property(assign,nonatomic)BOOL isDetail;  // 涉及收银台的返回方式。
//@property(assign,nonatomic)BOOL isCart;  // 涉及收银台的返回方式。

@property(strong,nonatomic)ECOrdersObject *orderObject;


@property(strong,nonatomic)NSNumber *pointNum;  //使用的积分数量
@property(strong,nonatomic)NSNumber *pointFee;  //使用的积分数量
@property(strong,nonatomic)NSString *voucherStr;
@property(strong,nonatomic)NSNumber *voucherFee;  // 产生的优惠卷的优惠金额

@property(strong,nonatomic)NSNumber *feightFee;  // 运费

@property(nonatomic)BOOL isOrderpay;

//@property(nonatomic)BOOL showID;

@end
