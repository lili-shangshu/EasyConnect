//
//  SetViewController.h
//  IosBasic
//
//  Created by Star on 2017/11/14.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface SetViewController : NARootController

@property (nonatomic, strong) void(^loginoutButtonClicked)(BOOL success);

@end
