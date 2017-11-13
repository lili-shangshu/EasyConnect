//
//  BillController.h
//  IosBasic
//
//  Created by junshi on 16/8/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"


@interface BillController : NARootController

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
