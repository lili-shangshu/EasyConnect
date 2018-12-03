//
//  LoginViewController.h
//  IosBasic
//
//  Created by li jun on 17/4/11.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NARootController.h"

@interface LoginViewController : NARootController
@property (nonatomic, strong) void(^loginResultforName)(NSString *username);

@property (nonatomic, strong) void(^loginResultBlock)(BOOL success);
@end
