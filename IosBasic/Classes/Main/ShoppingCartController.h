//
//  ShoppingCartController.h
//  IosBasic
//
//  Created by li jun on 16/10/14.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface ShoppingCartController : NARootController

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) BOOL isDetail;

@property(nonatomic)BOOL showHome;
@end
