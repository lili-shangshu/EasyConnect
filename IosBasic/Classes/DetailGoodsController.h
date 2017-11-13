//
//  DetailGoodsController.h
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@protocol DetailGoodsControllerDelegate <NSObject>

- (void)gethtml:(NSString *)heml;

@end

@interface DetailGoodsController : NARootController

@property(weak,nonatomic)id<DetailGoodsControllerDelegate>delegate ;
@property(strong,nonatomic) NSString * goodsId;
@property (nonatomic, strong) void(^commentButtonBlock)();
@property (nonatomic, strong) void(^collectButtonBlock)(NSString *isCollect);
@end
