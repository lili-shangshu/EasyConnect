//
//  LoginController.h
//  IosBasic
//
//  Created by li jun on 16/11/1.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

// 暂停使用

@interface LoginController : NARootController

// 返回登陆者的姓名
@property (nonatomic, strong) void(^loginResultforName)(NSString *username);

@property (nonatomic, strong) void(^loginResultBlock)(BOOL success);

@end
