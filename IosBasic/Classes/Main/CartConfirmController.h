//
//  CartConfirmController.h
//  IosBasic
//
//  Created by Apple on 16/10/16.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface CartConfirmController : NARootController

@property(strong,nonatomic)NSArray *cartsArray;

@property(strong,nonatomic)NSArray *deliceryArray;  // 快递公司

@property(strong,nonatomic) NSMutableDictionary * sendDic;
@property(strong,nonatomic) ECAddress * selectAddress ;
@property (nonatomic,strong) NSString *freight_hash;
@property (nonatomic,strong) NSString *goodsID; // 拼接的购物车ID

@property(nonatomic)float totalMoney;  // 商品合集
@property(nonatomic)float discountMoney; // 抵扣的



@property(assign,nonatomic)BOOL isDetail;  // 涉及收银台的返回方式。
@property(assign,nonatomic)BOOL isCart;  // 涉及收银台的返回方式。

@property(nonatomic)BOOL showHome;

// 总共会有三种，1 商品直接购买  2购物车购买  3订单中支付
@end
