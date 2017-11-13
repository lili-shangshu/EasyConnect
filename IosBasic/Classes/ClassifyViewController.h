//
//  ClassifyViewController.h
//  IosBasic
//
//  Created by li jun on 17/4/15.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface ClassifyViewController : NARootController

@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
