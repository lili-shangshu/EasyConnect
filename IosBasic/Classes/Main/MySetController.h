//
//  MySetController.h
//  IosBasic
//
//  Created by li jun on 16/10/10.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface MySetController : NARootController

@property(nonatomic)BOOL imageBool;
@property(nonatomic)BOOL messageBool;

@property (nonatomic, strong) void(^leaveBlock)(NSString *username); // 退出时 设置登录/注册

@end
