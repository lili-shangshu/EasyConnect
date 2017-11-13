//
//  OrdersController.h
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface OrdersController : NARootController

@property(nonatomic) int typeIndex ;

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end
