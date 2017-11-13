//
//  OrdersMessageController.h
//  IosBasic
//
//  Created by li jun on 16/12/15.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

// 余额管理
@interface BalanceController : NARootController
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
