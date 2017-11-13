//
//  WarehouseController.h
//  IosBasic
//
//  Created by Star on 2017/6/21.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface WarehouseController : NARootController
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) void(^selectResultBlock)(WarehouseObject *obj);

@end
