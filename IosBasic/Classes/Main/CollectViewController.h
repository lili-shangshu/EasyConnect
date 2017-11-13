//
//  CollectViewController.h
//  IosBasic
//
//  Created by li jun on 16/10/12.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface CollectViewController : NARootController
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
