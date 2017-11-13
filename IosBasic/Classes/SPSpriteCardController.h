//
//  SPSpriteCardController.h
//  IosBasic
//
//  Created by Star on 2017/9/29.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface SPSpriteCardController : NARootController

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *orderId;

@property(nonatomic)BOOL isPay;

@property(nonatomic,strong) NSString *isUseMoney;
@property (nonatomic, strong) void(^payResult)(BOOL success);

@end
