//
//  CommentController.h
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface CommentController : NARootController
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
