//
//  ClassifyGoodsController.h
//  IosBasic
//
//  Created by li jun on 16/10/19.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface ClassifyGoodsController : NARootController

@property (nonatomic, assign) NSString *classifyIndex;
@property (nonatomic, strong) NSString * searchWord;
@property (nonatomic , assign) BOOL isFromSearch;
@property (nonatomic , assign) BOOL isFirstIn;
@property (nonatomic,strong) NSString *brandId;


@property (nonatomic, strong) NSMutableDictionary *filterDictionary;


@property (nonatomic,strong) NSMutableArray *dataArray;
@end
