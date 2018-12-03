//
//  ChatRecordController.h
//  IosBasic
//
//  Created by junshi on 2017/8/3.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface ChatController : NARootController
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, assign) NSString *tid;
@property (nonatomic,strong) NSMutableArray *dataArray;
- (void)refreshTableWithUpdate;
@end
